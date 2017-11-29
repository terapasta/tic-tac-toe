class AccuracyTestCasePolicy < ApplicationPolicy
  def permitted_attributes
    [
      :question_text,
      :expected_text,
      :is_expected_suggestion
    ]
  end
end