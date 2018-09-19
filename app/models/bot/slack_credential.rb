class Bot::SlackCredential < ApplicationRecord
  belongs_to :bot
  validate :team_id, presence: true
  validates :microsoft_app_id, presence: true
  validates :microsoft_app_password, presence: true
end
