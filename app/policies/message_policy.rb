class MessagePolicy < ApplicationPolicy
  def update?
    staff_or_owner?
  end

  private
    def target_bot
      record.chat.bot
    end
end
