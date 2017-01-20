module BotUsable
  extend ActiveSupport::Concern

  def bots
    current_user.try(:staff?) ? Bot : current_user.try(:bots)
  end
end
