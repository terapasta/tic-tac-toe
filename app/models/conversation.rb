class Conversation
  NUMBER_OF_CONTEXT = 1

  def initialize(message)
    @message = message
    @ModelClass = message.class
  end

  def reply
    client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    context = build_context
    Rails.logger.debug("Conversation#reply context: #{context}, body: #{@message.body}")

    answer_id = client.call(:reply, context, @message.body)
    Rails.logger.debug("answer_id: #{answer_id}")
    Answer.find(answer_id)
  end

  private
    def build_context
      messages = @ModelClass.where('answer_id is not null').order('id desc').limit(NUMBER_OF_CONTEXT)
      answer_ids = messages.pluck(:answer_id)
      Array.new(NUMBER_OF_CONTEXT).fill(0).concat(answer_ids)[-NUMBER_OF_CONTEXT, NUMBER_OF_CONTEXT]
    end

end
