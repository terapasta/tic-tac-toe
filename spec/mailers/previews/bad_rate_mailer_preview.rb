class BadRateMailerPreview <  ActionMailer::Preview
  def create
    bot = Bot.new(id: 0, name: 'サンプルボット')
    chat = Chat.new(bot: bot)
    bot_users = [User.new(email: 'sample@example.com')]
    bot_message = Message.new(body: 'bot_message', chat: chat)
    guest_message = Message.new(body: 'guest_message', chat: chat)

    bot_message.bad_reasons = [BadReason.new(body: 'example reason')]

    BadRateMailer.create(bot_message, bot_users: bot_users, guest_message: guest_message)
  end
end