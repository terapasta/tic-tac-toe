class BotPolicy < ApplicationPolicy
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
    false
  end

  def edit?
    update?
  end

  def update?
    user.normal?
  end

  def destroy?
    false
  end
end
