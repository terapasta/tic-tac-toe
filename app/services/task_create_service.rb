class TaskCreateService
  def initialize(message, bot)
    @message = message
    @bot = bot
  end

  def process
    guest_message, bot_message = Message.find_pair_message_bodies_from(@message)
    if guest_message.present?
      Task.create(
        bot_message: (bot_message if @message.answer_failed),
        guest_message: guest_message,
        bot_id: @bot.id,
      )
    end
  end
end
