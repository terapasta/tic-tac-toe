class Bot::ChatworkCredential < ApplicationRecord
  belongs_to :bot
  validates :api_token, presence: true
  validates :webhook_token, presence: true
end
