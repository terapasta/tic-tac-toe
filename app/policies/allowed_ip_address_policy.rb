class AllowedIpAddressPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def new?
    user.normal? || user.staff?
  end

  def create?
    user.normal? || user.staff?
  end

  def edit?
    update?
  end

  def update?
    user.normal? || user.staff?
  end

  def destroy?
    user.normal? || user.staff?
  end

  def permitted_attributes
    [:value]
  end
end
