class TopicTagPolicy < ApplicationPolicy
  def index?
    user.staff? || user.normal?
  end

  def show?
    has_owner_permission?
  end

  def new?
    user.staff? || user.normal?
  end

  def create?
    has_owner_permission?
  end

  def edit?
    update?
  end

  def update?
    has_owner_permission?
  end

  def destroy?
    has_owner_permission?
  end

  def permitted_attributes
    [
      :name,
    ]
  end

  class Scope < Scope
    def resolve
      if user.staff?
        scope
      else
        scope.where(bot_id: user.bots.first.id)
      end
    end
  end

  private
    def has_owner_permission?
      return true if user.staff?
      user.normal? && record.bot.user = user
    end
end
