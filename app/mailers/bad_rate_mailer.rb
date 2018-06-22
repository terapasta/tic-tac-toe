class BadRateMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(message, bot_users: [], guest_message: nil, task: nil)
    @bot_users = bot_users.presence || message.chat.users.select(&:email_notification)
    @bot_message = message
    @guest_message = guest_message.presence || Chat.question_message(message.chat_id, message.id)
    @task = task

    @guest_user = @guest_message.chat.guest_user
    if @guest_user.present?
      @guest_name = " (#{[@guest_user.name, @guest_user.email].select(&:present?).join(' ')})"
    end

    unless @bot_users.length.zero?
      mail(to: @bot_users.map(&:email), subject: '[My-ope] チャットで回答によくない評価がつきました')
    end
  end
end
