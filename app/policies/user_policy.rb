class UserPolicy < ApplicationPolicy
  def index?
    user.staff?
  end

  def show?
    user.staff? || (user.normal? && record == user)
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    user.staff? || (user.normal? && record == user)
  end

  def destroy?
    user.staff? && record != user
  end
end
