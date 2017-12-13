class Bot::MicrosoftCredential < ApplicationRecord
  belongs_to :bot
  validates :app_id, presence: true
  validates :app_password, presence: true
end
