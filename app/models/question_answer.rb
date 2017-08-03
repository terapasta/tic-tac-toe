class QuestionAnswer < ActiveRecord::Base
  include HasManySentenceSynonyms

  paginates_per 100

  belongs_to :bot
  belongs_to :answer_data, class_name: 'Answer', foreign_key: :answer_id
  has_many :decision_branches, dependent: :destroy
  has_many :topic_taggings, dependent: :destroy, inverse_of: :question_answer
  has_many :topic_tags, through: :topic_taggings
  has_many :answer_files, dependent: :destroy, inverse_of: :answer

  # accepts_nested_attributes_for :answer
  accepts_nested_attributes_for :topic_taggings, allow_destroy: true
  accepts_nested_attributes_for :answer_files, allow_destroy: true

  NO_CLASSIFIED_ID = 0

  serialize :underlayer

  validates :question, presence: true
  validates :answer, presence: true

  scope :completed_count_for, -> (user_id, target_date) {
    joins(:sentence_synonyms)
      .merge(SentenceSynonym.target_user(user_id))
      .merge(SentenceSynonym.target_date(target_date))
      .uniq
      .count
  }

  scope :topic_tag, -> (topic_tag_id) {
    if topic_tag_id.present?
      if topic_tag_id.to_i == -1
        where('id NOT IN (SELECT DISTINCT(question_answer_id) FROM topic_taggings)')
      else
        joins(:topic_tags).where(topic_tags: {id: topic_tag_id})
      end
    end
  }

  scope :not_have_any_sentence_synonyms_count, -> {
    includes(:sentence_synonyms)
      .where(sentence_synonyms: {id: nil})
      .count
  }

  scope :group_by_sentence_synonyms, -> {
    joins(:sentence_synonyms)
      .group(:question_answer_id)
      .count
  }

  scope :keyword, -> (_keyword) {
    if _keyword.present?
      _kw = "%#{_keyword}%"
      where('question LIKE ? OR answer LIKE ?', _kw, _kw)
    end
  }

  def no_classified?
    bot.nil?
  end

  def self.import_csv(file, bot, options = {})
    CsvImporter.new(file, bot, options).tap(&:import)
  end

  def self_and_deep_child_decision_branches
    all = [self, *decision_branches]
    tails = decision_branches
    next_tails = nil
    get_next_dbs = -> (dbs) {
      dbs.map(&:child_decision_branches).flatten.compact
    }
    begin
      all += tails = next_tails || get_next_dbs.call(tails)
      next_tails = get_next_dbs.call(tails)
    end while next_tails.count > 0
    all
  end

  def self.find_or_null_question_answer(question_answer_id, bot, probability, classify_threshold)
    if question_answer_id.blank? || question_answer_id == NO_CLASSIFIED_ID || probability < classify_threshold
      NullQuestionAnswer.new(bot)
    else
      QuestionAnswer.find(question_answer_id)
    end
  end
end
