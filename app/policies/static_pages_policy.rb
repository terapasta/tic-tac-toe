class StaticPagesPolicy < ApplicationPolicy
  def help?
    !user.worker?
  end

  def can_use_nav?(bot)
    bot.present? && (user.normal? || user.staff?)
  end
end
