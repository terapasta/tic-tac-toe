class Organization::BotOwnership < ApplicationRecord
  belongs_to :organization
  belongs_to :bot

  # validates :bot_id, uniqueness: { message: 'は複数のOrganizationに所属できません' }
end
