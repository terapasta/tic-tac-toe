class WordMapping < ActiveRecord::Base
  belongs_to :bot
  has_many :word_mapping_synonyms
  accepts_nested_attributes_for :word_mapping_synonyms, allow_destroy: true

  validates :word,
    presence: true,
    length: { maximum: 20 }

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

    # def unique_pair
    #   if WordMapping.exists?(bot_id: bot_id, word: word, synonym: synonym)
    #     errors.add :base, '単語と同意語の組み合わせは既に存在しています'
    #   end
    # end
    # 
    # def word_is_not_eq_synonym
    #   if word == synonym
    #     errors.add :base, '単語と同義語を同じにはできません'
    #   end
    # end
    # 
    # def word_is_not_eq_other_synonym
    #   if WordMapping.exists?(synonym: word, bot_id: bot_id)
    #     errors.add :word, 'はすでに登録されている同義語を登録できません'
    #   end
    # end

    def strip_word_and_synonym
      word.strip!
      synonym.strip!
    end
end
