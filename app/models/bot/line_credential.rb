class Bot::LineCredential < ApplicationRecord
  belongs_to :bot
  validates :channel_id, presence: true
  validates :channel_secret, presence: true
  validates :channel_access_token, presence: true
end
