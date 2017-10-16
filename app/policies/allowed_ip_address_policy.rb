class AllowedIpAddressPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def new?
    create?
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
    [:value]
  end

  private
    def target_bot
      record.bot
    end
end
