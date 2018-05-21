class AnswerInlineImage < ApplicationRecord
  belongs_to :bot

  validates :file, presence: true
  validates :uuid, presence: true

  mount_uploader :file, AnswerInlineImageUploader

  before_validation do
    self.uuid ||= SecureRandom.uuid
  end
end
