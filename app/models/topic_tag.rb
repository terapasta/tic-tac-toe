class TopicTag < ActiveRecord::Base
  belongs_to :bot

  validates :name, presence: true
end
