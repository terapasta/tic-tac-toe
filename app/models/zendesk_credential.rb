class ZendeskCredential < ApplicationRecord
  belongs_to :bot

  validates :url, presence: true
  validates :username, presence: true
  validates :access_token, presence: true
end
