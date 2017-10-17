class GuestUserPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :name,
      :email
    ]
  end
end
