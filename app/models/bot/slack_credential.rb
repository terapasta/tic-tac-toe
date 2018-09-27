class Bot::SlackCredential < ApplicationRecord
  belongs_to :bot
  validates :team_id, presence: true
  validates :microsoft_app_id, presence: true
  validates :microsoft_app_password, presence: true
end
