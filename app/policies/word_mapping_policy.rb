class WordMappingPolicy < ApplicationPolicy
  def index?
    user.normal?
  end

  def show?
    user.normal?
  end

  def new?
    create?
  end

  def create?
    user.normal?
  end

  def edit?
    update?
  end

  def update?
    user.normal?
  end

  def destroy?
    user.normal?
  end
end
