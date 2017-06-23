class TaskCreateService
  def initialize(bot_messages, bot)
    @bot_messages = bot_messages
    @failed_bot_messages = @bot_messages.select(&:answer_failed)
    @bot = bot
  end

  def process
    @failed_bot_messages.each do |bot_message|
      guest_message = Message.find_pair_message_from(bot_message)
      next if guest_message.nil?

      Task.create(
        bot_message: (bot_message.body if bot_message.bad?),
        guest_message: guest_message.body,
        bot_id: @bot.id,
      )
    end
  end
end
