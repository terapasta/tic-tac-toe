class UserContext
  attr_reader :user, :session, :cookies

  def initialize(user:, session:, cookies:)
    @user = user
    @session = session
    @cookies = cookies
  end

  def method_missing(method_name, *args)
    if user.respond_to?(method_name)
      user.send(method_name, *args)
    else
      fail NoMethodError.new('undefined method', method_name, *args)
    end
  end
end
