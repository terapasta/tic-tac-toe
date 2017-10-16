class Organization::BotOwnership < ApplicationRecord
  belongs_to :organization
  belongs_to :bot
end
