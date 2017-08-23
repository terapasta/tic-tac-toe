class WordMapping < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with WordMappingValidator

  belongs_to :bot
  has_many :word_mapping_synonyms
  accepts_nested_attributes_for :word_mapping_synonyms, allow_destroy: true

  validates :word,
    presence: true,
    length: { maximum: 20 }
  #
  # validates :synonym,
  #   presence: true,
  #   length: { maximum: 20 },
  #   uniqueness: { scope: [:bot_id] }

  # validate :unique_pair
  # validate :word_is_not_eq_synonym
  # validate :word_is_not_eq_other_synonym

  before_validation :strip_word_and_synonym

  scope :for_bot, -> (bot) {
    where("bot_id IS NULL OR bot_id = :bot_id", bot_id: bot&.id)
  }

  scope :keyword, -> (_keyword) {
    if _keyword.present?
      _kw = "%#{_keyword}%"
      where('word LIKE ? OR synonym LIKE ?', _kw, _kw)
    end
  }

  private
    def strip_word_and_synonym
      word.strip!
    end
end
