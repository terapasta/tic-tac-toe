class AnswerInlineImage < ApplicationRecord
  validates :file, presence: true
  mount_uploader :file, AnswerInlineImageUploader
end
