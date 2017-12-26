class TaskCreateService
  def initialize(bot_messages_or_message, bot, current_user)
    @bot_messages = bot_messages_or_message
    unless bot_messages_or_message.is_a?(Array)
      @bot_messages = [bot_messages_or_message]
    end
    @failed_bot_messages = @bot_messages.select(&:answer_failed).presence ||
                           @bot_messages.select {|x| x.rating&.bad?}
    @bot = bot
    @current_user = current_user
  end

  def process
    return if @current_user.try(:staff?)
    @failed_bot_messages.each do |bot_message|
      guest_message = Message.find_pair_message_from(bot_message)
      next if guest_message.nil?

      task = Task.create(
        bot_message: (bot_message.body if bot_message.rating&.bad?),
        guest_message: guest_message.body,
        bot_id: @bot.id,
      )
      yield task if block_given?
    end
  end
end
