class BotPolicy < ApplicationPolicy
  def index?
    user.normal? || user.staff?
  end

  def admin_show?
    user.staff?
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

  def exceeded_chats_count?
    record.chats.today_count_of_guests > record.user.chats_limit_per_day
  end

  def permitted_attributes
    [
      :name,
      :image,
      :remove_image,
      :classify_failed_message,
      :start_message,
      :has_suggests_message,
      :enable_guest_user_registration,
      {
        allowed_hosts_attributes: [
          :id,
          :scheme,
          :domain,
          :_destroy,
        ],
        allowed_ip_addresses_attributes: [
          :id,
          :value,
          :_destroy,
        ],
        topic_tags_attributes: [
          :id,
          :name,
          :_destroy,
        ]
      },
    ]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.staff?
        scope
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
