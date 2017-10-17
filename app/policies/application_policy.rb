class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user.presence || DummyUser.new
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private
    def staff_or_owner?
      return true if user&.staff?
      user&.has_membership_of?(target_bot)
    end

    def target_bot
      fail "you must implement #{self.class.name}#target_bot method"
    end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user || DummyUser.new
      @scope = scope
    end

    def resolve
      scope
    end
  end

  class DummyUser
    def nil?
      true
    end

    def blank?
      true
    end

    def method_missing(method, *args)
      false
    end
  end
end
