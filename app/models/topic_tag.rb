class TopicTag < ApplicationRecord
  belongs_to :bot, required: true
  has_many :topic_taggings, dependent: :destroy
  has_many :question_answers, through: :topic_taggings

  validates :name, presence: true, format: { with: /\A[^\/／]+\z/ }
end
