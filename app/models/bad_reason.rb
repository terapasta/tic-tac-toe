class BadReason < ApplicationRecord
  belongs_to :message
  belongs_to :guest_user, required: false

  validates :body, presence: true
end
