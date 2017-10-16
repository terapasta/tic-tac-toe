class BadRateMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(message)
    @bot_users = message.chat.bot_users
    @bot_message = message
    @guest_message = Chat.question_message(message.chat_id, message.id)
    mail(to: @bot_users.map(&:email), subject: '[My-ope office] チャットで回答によくない評価がつきました')
  end
end
