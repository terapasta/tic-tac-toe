class AnswerFile < ActiveRecord::Base
  belongs_to :answer

  validates :answer_id, presence: true
  validates :file, presence: true
  validates :file_type, presence: true

  mount_uploader :file, AnswerFileUploader

  before_validation :set_file_type_and_size_if_needed

  private
    def set_file_type_and_size_if_needed
      if file.present? && file_changed?
        self.file_type = file.file.content_type
        self.file_size = file.file.size
      end
    end
end
