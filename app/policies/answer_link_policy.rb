class AnswerLinkPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :answer_record_id,
      :answer_record_type
    ]
  end
end