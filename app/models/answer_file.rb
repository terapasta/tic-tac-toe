class AnswerFile < ApplicationRecord
  belongs_to :question_answer, required: false
  belongs_to :decision_branch, required: false

  validates :file, presence: true
  validates :file_type, presence: true
  validates :question_answer,
    presence: true,
    if: -> (it) { it.decision_branch.blank? }
  validates :decision_branch,
    presence: true,
    if: -> (it) { it.question_answer.blank? }

  mount_uploader :file, AnswerFileUploader

  before_validation :set_file_type_and_size_if_needed

  def image?
    file_type.present? && file_type.split('/').first == 'image'
  end

  private
    def set_file_type_and_size_if_needed
      if file.present? && file_changed?
        self.file_type = file.file.content_type
        self.file_size = file.file.size
      end
    end
end
