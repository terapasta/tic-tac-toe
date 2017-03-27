class StaticPagesPolicy < ApplicationPolicy
  def help?
    !user.worker?
  end

  def can_use_nav?(bot)
    return false if bot.blank? || user.worker? || bot.is_limited
    true
  end
end
