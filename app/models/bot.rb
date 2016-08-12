class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :answers
  belongs_to :start_answer, class_name: 'Answer', foreign_key: :start_answer_id
end
