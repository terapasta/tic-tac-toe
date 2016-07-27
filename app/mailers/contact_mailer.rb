class ContactMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(contact_state)
    @contact_state = contact_state
    mail(to: @contact_state.email, subject: 'お問い合わせがありました')
  end
end
