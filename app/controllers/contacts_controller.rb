class ContactsController < ApplicationController
  def new
  end

  def create
    client = ZendeskClient.shared_client
    ticket = ZendeskAPI::Ticket.new(client,
      subject:     "サポートフォームからのお問い合わせ<#{current_user.email}>",
      description: params[:ticket][:description]
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
