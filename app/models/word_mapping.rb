class WordMapping < ActiveRecord::Base
  belongs_to :user

  validates :word, presence: true, length: { maximum: 20 }
  validates :synonym, presence: true, length: { maximum: 20 }

  validate :unique_pair

  scope :for_user, -> (user) { where "user_id IS NULL OR user_id = :user_id", user_id: user&.id }

  private

    def unique_pair
      if WordMapping.exists?(user_id: user_id, word: word, synonym: synonym)
        errors.add :base, '単語と同意語の組み合わせは既に存在しています。'
      end
    end
end
