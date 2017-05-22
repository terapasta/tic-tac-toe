class AnswerFile < ActiveRecord::Base
  belongs_to :answer

  validates :answer_id, presence: true
  validates :file, presence: true

  mount_uploader :file, AnswerFileUploader
end
