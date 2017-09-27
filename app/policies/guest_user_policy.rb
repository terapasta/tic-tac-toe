class GuestUserPolicy < ApplicationPolicy
  def show?
    writable?
  end

  def create?
    user_guest_key.present?
  end

  def update?
    writable?
  end

  def destroy?
    writable?
  end

  def permitted_attributes
    [
      :name,
      :email
    ]
  end

  private
    def user_guest_key
      user.cookies.try(:[], :guest_key)
    end

    def writable?
      record.guest_key == user_guest_key
    end
end
