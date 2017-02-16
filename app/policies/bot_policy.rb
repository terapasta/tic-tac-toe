class BotPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def show?
    update?
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

  def reset?
    update?
  end

  def permitted_attributes
    [
      :name,
      :image,
      :classify_failed_message,
      :start_message,
      {
        allowed_hosts_attributes: [
          :id,
          :scheme,
          :domain,
          :_destroy,
        ],
      },
    ]
  end
end
