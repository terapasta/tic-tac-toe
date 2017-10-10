class Organization::BotOwnership < ActiveRecord::Base
  belongs_to :organization
  belongs_to :bot
end
