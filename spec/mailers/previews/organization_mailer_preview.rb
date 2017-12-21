class OrganizationMailerPreview < ActionMailer::Preview
  def notify_before_1week_of_finishing_trial
    user = User.new(email: 'sample@example.com')
    org = Organization.new
    org.user_memberships << Organization::UserMembership.new(user: user)
    OrganizationMailer.notify_before_1week_of_finishing_trial(org)
  end
end