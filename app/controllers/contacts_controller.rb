class ContactsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    client = ZendeskClient.shared_client
    ticket = ZendeskAPI::Ticket.new(client, requester: {email: (ticket_params[:email])},
      subject:(ticket_params[:subject]),
      description: (ticket_params[:description]))
    if ticket.save
      redirect_to root_path, notice: 'お問い合わせが完了しました。'
    else
      redirect_to new_contacts_path,
        alert: 'お問い合わせに失敗しました。内容を確認してください。
                * メールアドレスは入力されましたか?
                * お問い合わせ内容は入力されましたか?'
    end
  end

  private
    def ticket_params
      params.require(:ticket).permit(:email, :subject, :description)
    end
end
