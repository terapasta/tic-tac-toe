module User::OrganizationMembershipable
  extend ActiveSupport::Concern

  included do
    has_many :bots, through: :organizations
    has_many :organization_memberships, class_name: 'Organization::UserMembership'
    has_many :organizations, through: :organization_memberships
  end

  def plan(bot)
    detect_organization_from(bot)&.plan
  end

  def ec_plan?(bot)
    detect_organization_from(bot)&.ec_plan?
  end

  def histories_limit_days(bot)
    detect_organization_from(bot)&.histories_limit_days
  end

  def histories_limit_time(bot)
    detect_organization_from(bot)&.histories_limit_time
  end

  def chats_limit_per_day(bot)
    detect_organization_from(bot).chats_limit_per_day
  end

  def detect_organization_from(bot)
    organizations.detect{ |org| org.bots.include?(bot) }
  end

  def has_membership_of?(bot)
    detect_organization_from(bot).present?
  end
end
