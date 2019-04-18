class QuestionAnswer < ApplicationRecord
  include HasManySentenceSynonyms

  paginates_per 100

  belongs_to :bot
  has_many :decision_branches,
    -> { order(position: :asc) },
    dependent: :destroy
  has_many :topic_taggings, dependent: :destroy, inverse_of: :question_answer
  has_many :topic_tags, through: :topic_taggings
  has_many :answer_files, dependent: :destroy
  has_many :answer_links, as: :answer_record
  has_many :sub_questions, dependent: :destroy
  has_many :initial_selection, dependent: :destroy
  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :topic_taggings, allow_destroy: true
  accepts_nested_attributes_for :answer_files, allow_destroy: true
  accepts_nested_attributes_for :decision_branches
  accepts_nested_attributes_for :sub_questions, allow_destroy: true

  NO_CLASSIFIED_ID = 0

  validates :question, presence: true

  after_create do
    self.bot&.tutorial&.done_fifty_question_answers_if_needed!
  end

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
        where('id IN (SELECT DISTINCT(question_answer_id) FROM topic_taggings)')
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
      ransack(question_or_answer_or_sub_questions_question_cont: _keyword).result
    end
  }

  scope :keyword_for_answer, -> (_keyword) {
    if _keyword.present?
      _kw = "%#{_keyword}%"
      where('question_answers.answer LIKE ?', _kw)
    end
  }

  scope :for_suggestion, -> () {
    left_joins(:topic_tags)
      .where(topic_tags: { is_show_in_suggestion: true })
      .or(left_joins(:topic_tags).where(topic_tags: { id: nil }))
  }

  before_destroy do
    break if self.bot.blank?
    if self.bot.selected_question_answer_ids.include?(self.id)
      self.bot.selected_question_answer_ids -= [self.id]
      self.bot.save!
    end
  end

  def no_classified?
    # bot.nil?
    false
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

  def self.find_all_or_null_question_answers(question_answer_ids, bot)
    qa_ids = question_answer_ids.select{ |id| id > 0 }
    qas = where(id: qa_ids).to_a
    index = 0
    results = []
    while index < question_answer_ids.count
      id = question_answer_ids[index]
      if id != 0
        results.push(qas.detect{ |qa| qa.id == id })
      else
        results.push(NullQuestionAnswer.new(bot))
      end
      index += 1
    end
    results
  end

  def sub_question?
    false
  end
end
