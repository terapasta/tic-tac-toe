class ZendeskCredential < ApplicationRecord
  belongs_to :bot

  validate :url, presence: true
  validate :username, presence: true
  validate :access_token, presence: true
end
