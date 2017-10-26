class TopicTag < ApplicationRecord
  belongs_to :bot, required: true
  has_many :topic_taggings, dependent: :destroy
  has_many :question_answers, through: :topic_taggings

  validates :name, presence: true, format: { with: /\A[^\/／]+\z/ }

  validate :must_be_unique

  def must_be_unique
    if bot.present?
      errors.add(:base, "タグ名「#{name}」は重複しています") if bot.topic_tags.pluck(:name).include?(name)
    end
  end
end
