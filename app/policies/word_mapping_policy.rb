class WordMappingPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    user.normal? || user.staff?
  end

  def new?
    create?
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
end
