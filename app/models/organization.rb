class Organization < ApplicationRecord
  has_many :user_memberships, class_name: 'Organization::UserMembership'
  has_many :users, through: :user_memberships
  has_many :bot_ownerships, class_name: 'Organization::BotOwnership'
  has_many :bots, through: :bot_ownerships

  accepts_nested_attributes_for :user_memberships, allow_destroy: true
  accepts_nested_attributes_for :bot_ownerships, allow_destroy: true

  enum plan: { lite: 0, standard: 1, professional: 2, trial: 3 }

  mount_uploader :image, ImageUploader

  HistoriesLimitDays = {
    lite: 3,
    standard: 7,
    professional: Float::INFINITY,
  }.with_indifferent_access.freeze

  ChatsLimitPerDay = {
    lite: 30,
    standard: 60,
    professional: Float::INFINITY,
  }.with_indifferent_access.freeze

  def histories_limit_days
    HistoriesLimitDays[plan]
  end

  def histories_limit_time
    histories_limit_days.days.ago.beginning_of_day
  end

  def chats_limit_per_day
    ChatsLimitPerDay[plan]
  end

  def ec_plan?
    lite? || standard?
  end
end
