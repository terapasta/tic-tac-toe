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

  before_validation :strip_word, :set_word_wakati

  scope :for_bot, -> (bot) {
    where("bot_id IS NULL OR bot_id = :bot_id", bot_id: bot&.id)
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

  def set_word_wakati
    self.word_wakati = Wakatifier.apply(word)
  end

  private
    def strip_word
      word.strip!
    end
end
