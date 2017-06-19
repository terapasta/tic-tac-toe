class WordMapping < ActiveRecord::Base
  belongs_to :bot

  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }

  validate :unique_pair
  validate :word_is_not_in_synonyms
  validate :word_is_not_eq_synonym

  before_validation :strip_word_and_synonym

  scope :for_user, -> (user) { where "user_id IS NULL OR user_id = :user_id", user_id: user&.id }

  private

    def unique_pair
      if WordMapping.exists?(bot_id: bot_id, word: word, synonym: synonym)
        errors.add :base, '単語と同意語の組み合わせは既に存在しています。'
      end
    end

    def word_is_not_in_synonyms
      if WordMapping.exists?(bot_id: bot_id, synonym: word)
        errors.add :word, 'は既に同義語として登録されている単語は使用できません'
      end
    end

    def word_is_not_eq_synonym
      if word == synonym
        errors.add :base, '単語と同義語を同じにはできません'
      end
    end

    def strip_word_and_synonym
      word.strip!
      synonym.strip!
    end
end
