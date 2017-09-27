class UserContext
  attr_reader :user, :session, :cookies, :request

  def initialize(user:, session:, request:)
    @user = user
    @session = session
    @request = request
  end

  def presence
    user.presence
  end

  def method_missing(method_name, *args)
    return user.send(method_name) if user.is_a?(ApplicationPolicy::DummyUser)
    if user.respond_to?(method_name)
      user.send(method_name, *args)
    else
      fail NoMethodError.new('undefined method', method_name, *args)
    end
  end
end
