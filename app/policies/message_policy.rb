class MessagePolicy < ApplicationPolicy
  def update?
    staff_or_owner?
  end

  def permitted_attributes
    [
      :body
    ]
  end

  private
    def target_bot
      record.chat.bot
    end
end
