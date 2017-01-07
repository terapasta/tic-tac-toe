class SentenceSynonymPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.normal? || record.created_user == user
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    update?
  end

  def update?
    user.present?
  end

  def destroy?
    user.normal?
  end

  class Scope < Scope
    def resolve
      if user.normal?
        scope.all
      else
        scope.where(created_user_id: user.id)
      end
    end
  end
end