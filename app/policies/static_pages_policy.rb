class StaticPagesPolicy < ApplicationPolicy
  def help?
    user.normal?
  end
end
