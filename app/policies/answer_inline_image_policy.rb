class AnswerInlineImagePolicy < ApplicationPolicy
  def permitted_attributes
    [
      :file
    ]
  end
end