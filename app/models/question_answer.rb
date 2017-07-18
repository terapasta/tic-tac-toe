class QuestionAnswer < ActiveRecord::Base
  include HasManySentenceSynonyms

  paginates_per 100
  acts_as_taggable

  belongs_to :bot
  belongs_to :answer_data, class_name: 'Answer', foreign_key: :answer_id
  has_many :decision_branches
  has_many :topic_taggings, dependent: :destroy, inverse_of: :question_answer
  has_many :topic_tags, through: :topic_taggings
  has_many :answer_files, dependent: :destroy, inverse_of: :answer

  # accepts_nested_attributes_for :answer
  accepts_nested_attributes_for :topic_taggings, allow_destroy: true
  accepts_nested_attributes_for :answer_files, allow_destroy: true

  NO_CLASSIFIED_ID = 0

  serialize :underlayer

  validates :question, presence: true

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
      qa = QuestionAnswer.arel_table
      answers = Answer.arel_table
      kw = "%#{_keyword}%"
      joins(:answer).where(
        qa[:question].matches(kw)
        .or(answers[:body].matches(kw))
      )
    end
  }

  def no_classified?
    return true if bot.nil?
    false
  end

  def self.import_csv(file, bot, options = {})
    CsvImporter.new(file, bot, options).tap(&:import)
  end

  def self.find_or_null_question_answer(question_answer_id, bot, probability, classify_threshold)
    if question_answer_id.blank? || question_answer_id == NO_CLASSIFIED_ID || probability < classify_threshold
      NullQuestionAnswer.new(bot)
    else
      QuestionAnswer.find(question_answer_id)
    end
  end
end
