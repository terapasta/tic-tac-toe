class ContactsController < ApplicationController
  def new
  end

  def create
    client = ZendeskClient.shared_client
    user = client.users.search(query: current_user.email).fetch.first
    if user.blank?
      user = ZendeskAPI::User.new(client)
      user.name = current_user.email
      user.email = current_user.email
      user.save
    end
    ticket = ZendeskAPI::Ticket.new(client,
      subject: "#{params[:ticket][:subject]} <#{current_user.email}>",
      description: params[:ticket][:description],
      requester_id: user.id
    )
    if ticket.save
      redirect_to new_contacts_path, notice: 'お問い合わせが完了しました。'
    else
      flash.now.alert = <<~MSG
        お問い合わせに失敗しました。内容を確認してください。
        ※メールアドレスは入力されましたか?
        ※お問い合わせ内容は入力されましたか?
      MSG
      render :new
    end
  end
end
