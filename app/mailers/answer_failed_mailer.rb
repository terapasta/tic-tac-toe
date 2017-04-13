class AnswerFailedMailer < ApplicationMailer
  default from: 'noreply@mof-mof.co.jp'

  def create(message)
    @bot_user = message.chat.bot.user
    @bot_message = message
    @guest_message = Chat.question_message(message.chat.id, message.id)
    mail(to: @bot_user.email, subject: '[My-ope office] チャットで回答に失敗しました')
  end
end
