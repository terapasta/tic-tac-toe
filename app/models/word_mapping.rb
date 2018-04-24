class WordMapping < ApplicationRecord
  include ActiveModel::Validations
  validates_with WordMappingValidator

  belongs_to :bot
  has_many :word_mapping_synonyms
  accepts_nested_attributes_for :word_mapping_synonyms, allow_destroy: true

  validates :word,
    presence: true,
    length: { maximum: 20 },
    uniqueness: { scope: :bot_id }
  #
  # validates :synonym,
  #   presence: true,
  #   length: { maximum: 20 },
  #   uniqueness: { scope: [:bot_id] }

  # validate :unique_pair
  # validate :word_is_not_eq_synonym
  # validate :word_is_not_eq_other_synonym

  before_validation do
    strip_word
    self.word_wakati = Wakatifier.apply(word)
  end

  scope :for_bot, -> (bot) {
    bot_id = bot.respond_to?(:id) ? bot.id : bot
    where("bot_id IS NULL OR bot_id = :bot_id", bot_id: bot_id)
  }

  scope :keyword, -> (_keyword) {
    if _keyword.present?
      _kw = "%#{_keyword}%"
      joins(:word_mapping_synonyms).where('word LIKE ? OR word_mapping_synonyms.value LIKE ?', _kw, _kw).distinct
    end
  }

  scope :systems, -> {
    where(bot_id: nil)
  }

  class << self
    def replace_synonym_all!(bot_id)
      word_mappings = WordMapping.for_bot(bot_id).decorate
      question_answers = QuestionAnswer.where(bot_id: bot_id).select(:id, :question)
      ActiveRecord::Base.transaction do
        question_answers.each do |qa|
          qa.question_wakati = word_mappings.replace_synonym(qa.wakatify_question)
          qa.save!(validate: false) if qa.question_wakati_changed?
        end
      end
    end
  end

  private
    def strip_word
      word.strip!
    end
end
