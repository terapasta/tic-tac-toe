class AnswerInlineImage < ApplicationRecord
  belongs_to :bot

  validates :file, presence: true

  mount_uploader :file, AnswerInlineImageUploader
end
