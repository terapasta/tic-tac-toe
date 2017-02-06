class QuestionAnswer < ActiveRecord::Base
  include HasManySentenceSynonyms

  paginates_per 100
  acts_as_taggable

  belongs_to :bot
  belongs_to :answer
  has_many :training_messages, dependent: :nullify
  has_many :decision_branches, through: :answer

  serialize :underlayer

  validates :question, presence: true
  validates :answer_id, presence: true

  scope :completed_count_for, -> (user_id, target_date) {
    joins(:sentence_synonyms)
      .merge(SentenceSynonym.target_user(user_id))
      .merge(SentenceSynonym.target_date(target_date))
      .uniq
      .count
  }

  module Encoding
    SJIS = 'Shift_JIS'
    UTF8 = 'UTF-8'
    ModeEncForUTF8 = 'r'
    ModeEncForSJIS = "rb:#{SJIS}:#{UTF_8}"
  end

  # TODO: 戻り値を配列で返すのは一時対応なので、インポート処理を別クラスに移動していい感じにしたい
  def self.import_csv(file, bot, options = {})
    options = { is_utf8: false }.merge(options)
    mode_enc = options[:is_utf8] ? Encoding::ModeEncForUTF8 : Encoding::ModeEncForSJIS
    current_row = nil

    open(file.path, mode_enc, undef: :replace) do |f|
      transaction do
        CSV.new(f).each_with_index do |row, index|
          current_row = index + 1
          first_q = row[0]
          first_a = row[1]
          next if first_q.blank?

          current_answer = answer = bot.answers.find_or_create_by!(body: sjis_safe(first_a))

          question_answer = bot.question_answers.find_or_initialize_by(question: sjis_safe(first_q)).tap do |qa|
            qa.assign_attributes(answer: current_answer)
            qa.save!
          end

          if row.compact.count > 2
            row[2..-1].compact.each_slice(2) do |decision_branch_body, answer_body|
              decision_branch = current_answer.decision_branches.find_or_initialize_by(body: sjis_safe(decision_branch_body), bot_id: bot.id)
              if answer_body.present?
                current_answer = bot.answers.find_or_initialize_by(body: sjis_safe(answer_body), bot_id: bot.id)
                decision_branch.next_answer = current_answer
              end
              decision_branch.save!
            end
          end
        end
      end
    end
    [true]
  rescue => e
    Rails.logger.debug(e)
    Rails.logger.debug(e.backtrace.join("\n"))
    [false, current_row]
  end

  def self.sjis_safe(str)
    [
      ["FF5E", "007E"], # wave-dash
      ["FF0D", "002D"], # full-width minus
      ["00A2", "FFE0"], # cent as currency
      ["00A3", "FFE1"], # lb(pound) as currency
      ["00AC", "FFE2"], # not in boolean algebra
      ["2014", "2015"], # hyphen
      ["2016", "2225"], # double vertical lines
    ].inject(str) do |s, (before, after)|
      s.gsub(
        before.to_i(16).chr('UTF-8'),
        after.to_i(16).chr('UTF-8'))
    end
  end
end
