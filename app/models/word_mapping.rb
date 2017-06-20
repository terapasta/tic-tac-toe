class WordMapping < ActiveRecord::Base
  belongs_to :bot

  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }

  validate :unique_pair
  validate :word_is_not_eq_synonym

  before_validation :strip_word_and_synonym

  scope :for_bot, -> (bot) {
    where("bot_id IS NULL OR bot_id = :bot_id", bot_id: bot&.id)
  }

  private

    def unique_pair
      if WordMapping.exists?(bot_id: bot_id, word: word, synonym: synonym)
        errors.add :base, '単語と同意語の組み合わせは既に存在しています。'
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
