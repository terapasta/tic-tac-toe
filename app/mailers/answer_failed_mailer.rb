class AnswerFailedMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(message, task)
    @bot_users = message.chat.users.select(&:email_notification)
    @bot_message = message
    @chat = message.chat
    @guest_user = @chat.guest_user
    if @guest_user.present?
      @guest_name = " (#{[@guest_user.name, @guest_user.email].select(&:present?).join(' ')})"
    end
    @guest_message = Chat.question_message(message.chat_id, message.id)
    @task = task
    unless @bot_users.length.zero?
      mail(to: @bot_users.map(&:email), subject: '[My-ope] チャットで回答に失敗しました')
    end
  end
end
