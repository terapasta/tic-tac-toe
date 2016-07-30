class ContactState < ActiveRecord::Base
  belongs_to :chat

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # validates :name, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  # validates :body, presence: true
end
