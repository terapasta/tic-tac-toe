class QuestionAnswer < ActiveRecord::Base
  include HasManySentenceSynonyms

  paginates_per 100
  acts_as_taggable

  belongs_to :bot
  belongs_to :answer
  has_many :training_messages, dependent: :nullify
  has_many :decision_branches, through: :answer
  has_many :topic_taggings, dependent: :destroy
  has_many :topic_tags, through: :topic_taggings

  accepts_nested_attributes_for :answer
  accepts_nested_attributes_for :topic_taggings

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
      joins(:topic_tags).where(topic_tags: {id: topic_tag_id})
    end
  }

  scope :count_sentence_synonyms_all, -> (bot_id) {
    where('bot_id' => bot_id)
    .joins(:sentence_synonyms)
      .count
  }

  scope :count_sentence_synonyms_not_have, -> (bot_id) {
    where('bot_id' => bot_id)
    .includes(:sentence_synonyms)
      .where(sentence_synonyms: {id: nil})
      .count
  }

  scope :grouping_sentence_synonyms, -> (bot_id) {
    where('bot_id' => bot_id)
    .joins(:sentence_synonyms)
    .group(:training_message_id)
    .count
  }

  def self.import_csv(file, bot, options = {})
    CsvImporter.new(file, bot, options).tap(&:import)
  end
end

def count_sentence_synonyms_registration_number(grouping_sentence_synonyms)
  registration_number = {}

  grouping_sentence_synonyms.each_value{|value|
    case value
    when 3
      registration_number["3"] =+ 1
    when 6
      registration_number["6"] =+ 1
    when 9
      registration_number["9"] =+ 1
    when 12
      registration_number["12"] =+ 1
    when 15
      registration_number["15"] =+ 1
    when 18
      registration_number["18"] =+ 1
    end
   }
   return registration_number
end
