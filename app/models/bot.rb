class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
end
