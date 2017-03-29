class TopicTag < ActiveRecord::Base
  belongs_to :bot, required: true
  has_many :topic_taggings
  has_many :question_answers, through: :topic_taggings

  validates :name, presence: true
end
