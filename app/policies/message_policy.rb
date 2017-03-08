class MessagePolicy < ApplicationPolicy
  def answer_successable?
    record.answer_failed? && record.answer_failed_by_user?
  end
end
