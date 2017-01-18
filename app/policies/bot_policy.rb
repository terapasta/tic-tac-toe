class BotPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    user.staff? || (user.normal? && record.user == user)
  end

  def new?
    create?
  end

  def create?
    user.staff?
  end

  def edit?
    update?
  end

  def update?
    user.staff? || (user.normal? && record.user == user)
  end

  def destroy?
    user.staff?
  end
end
