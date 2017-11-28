class BadRateMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(message)
    @bot_users = message.chat.users.select(&:email_notification)
    @bot_message = message
    @guest_message = Chat.question_message(message.chat_id, message.id)
    unless @bot_users.length.zero?
      mail(to: @bot_users.map(&:email), subject: '[My-ope] チャットで回答によくない評価がつきました')
    end
  end
end
