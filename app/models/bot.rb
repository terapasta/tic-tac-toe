class Bot < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :trainings
  has_many :answers
  belongs_to :start_answer, class_name: 'Answer', foreign_key: :start_answer_id
  belongs_to :no_classified_answer, class_name: 'Answer', foreign_key: :no_classified_answer_id

  mount_uploader :image, ImageUploader
end
