class Organization < ActiveRecord::Base
  enum plan: { lite: 0, standard: 1, professional: 2 }

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
