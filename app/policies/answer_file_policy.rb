class AnswerFilePolicy < ApplicationPolicy
  def permitted_attributes
    [
      :file
    ]
  end
end