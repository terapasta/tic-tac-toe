class BadReasonPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :body
    ]
  end
end