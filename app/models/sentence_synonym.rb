class SentenceSynonym < ActiveRecord::Base
  belongs_to :training_message
  belongs_to :created_user, class_name: 'User'

  validates :body, presence: true
end
