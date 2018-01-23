class SubQuestionPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :question
    ]
  end
end