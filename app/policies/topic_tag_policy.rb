class TopicTagPolicy < ApplicationPolicy
  def index?
    user.staff? || user.normal?
  end

  def show?
    staff_or_owner?
  end

  def new?
    user.staff? || user.normal?
  end

  def create?
    staff_or_owner?
  end

  def edit?
    update?
  end

  def update?
    staff_or_owner?
  end

  def destroy?
    staff_or_owner?
  end

  def permitted_attributes
    [
      :name,
    ]
  end

  private
    def target_bot
      record.bot
    end
end
