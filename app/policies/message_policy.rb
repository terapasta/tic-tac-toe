class MessagePolicy < ApplicationPolicy
  def update?
    staff_or_owner?
  end

  private
    def staff_or_owner?
      user.staff? || record.chat.bot.user == user
    end
end
