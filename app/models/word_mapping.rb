class WordMapping < ActiveRecord::Base
  belongs_to :bot
  has_many :word_mapping_synonyms
  accepts_nested_attributes_for :word_mapping_synonyms, allow_destroy: true

  validates :word,
    presence: true,
    length: { maximum: 20 }

  validate :word_is_not_eq_synonym
  validate :unique_pair_word
  validate :word_is_not_eq_other_synonym

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
    def word_is_not_eq_synonym
      word_mapping_synonyms.each do |wms|
        if wms.value == word
          errors.add :base, '単語と同義語を同じにはできません'
        end
      end
    end

    def unique_pair_word
      values = word_mapping_synonyms.map(&:value)
      unless values.size == values.uniq.size
        errors.add :base, '同じ同意語は登録できません' 
      end
    end

    def word_is_not_eq_other_synonym
      if bot_id.nil?
        word_mappings = WordMapping.where(bot_id: nil)
      else
        word_mappings = WordMapping.where(bot_id: bot_id)
      end

      values = []
      word_mappings.each do |wm|
        wm.word_mapping_synonyms.each do |wms|
          values << wms.value
        end
      end

      values.each do |v|
        if word == v
          errors.add :base, 'この単語は既に同義語に登録されています'
        end
      end
    end

    def strip_word_and_synonym
      word.strip!
    end
end
