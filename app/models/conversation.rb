class Conversation
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message)
    @message = message
    @ModelClass = message.class
  end

  def reply
    if @message.contact?
    #   return Answer.find(Answer::STOP_CONTEXT_ID) if @message.body == NEGATIVE_WORD
    #   return Answer.find(Answer::ASK_GUEST_NAME_ID) if @message.body == POSITIVE_WORD
      return Answer.find(Answer::TRANSITION_CONTEXT_CONTACT_ID)
    end

    client = MessagePack::RPC::Client.new('127.0.0.1', 6000)
    context = build_context
    Rails.logger.debug("Conversation#reply context: #{context}, body: #{@message.body}")

    answer_id = client.call(:reply, context, @message.body)
    answer_id =  Answer::NO_CLASSIFIED_MESSAGE_ID if answer_id.nil?

    Rails.logger.debug("answer_id: #{answer_id}")
    Answer.find(answer_id)
  end

  private
    def build_context
      return [] if NUMBER_OF_CONTEXT < 0
      messages = @ModelClass.where('answer_id is not null').order('id desc').limit(NUMBER_OF_CONTEXT)
      answer_ids = messages.pluck(:answer_id)
      Array.new(NUMBER_OF_CONTEXT).fill(0).concat(answer_ids)[-NUMBER_OF_CONTEXT, NUMBER_OF_CONTEXT]
    end

end
