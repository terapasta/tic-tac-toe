class OrganizationMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def notify_before_1week_of_finishing_trial(organization)
    @orgnization = organization
    mail(
      to: @organization.users.map(&:email),
      subject: '[My-ope] フリープランの終了まであと1週間です'
    )
  end
end