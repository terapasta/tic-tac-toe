class WordMappingSynonym < ApplicationRecord
  belongs_to :word_mapping

  validates :value,
    presence: true,
    length: { maximum: 20 }

  scope :registered_synonym, -> (bot_id) {
    where(word_mapping_id: WordMapping.select(:id)
    .where(bot_id: bot_id))
  }

  before_validation do
    self.value_wakati = Wakatifier.apply(value)
  end
end
