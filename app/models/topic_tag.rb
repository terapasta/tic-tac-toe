class TopicTag < ActiveRecord::Base
  belongs_to :bot, required: true
  
  validates :name, presence: true
end
