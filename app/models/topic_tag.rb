class TopicTag < ApplicationRecord
  belongs_to :bot, required: true
  has_many :topic_taggings, dependent: :destroy
  has_many :question_answers, through: :topic_taggings

  validates :name, presence: true, format: { with: /\A[^\/／]+\z/ }

  validate :must_be_unique

  scope :without_by_id, -> (target_id) {
    where.not(id: target_id)
  }

  def must_be_unique
    return if bot.blank?
    if (persisted? && bot.topic_tags.without_by_id(id).pluck(:name).include?(name)) ||
       (!persisted? && bot.topic_tags.pluck(:name).include?(name))
      errors.add(:base, "タグ名「#{name}」は重複しています")
    end
  end
end
