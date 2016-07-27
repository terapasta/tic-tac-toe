class Conversation::Bot
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def self.responder(message)
    if message.contact? || transision_to_contact?(message)
      Conversation::Contact.new(message)
    else
      Conversation::Bot.new(message)
    end
  end

  # TODO 別クラスにする？
  def self.transision_to_contact?(message)
    last_answer = Message.bot.last.answer
    last_answer.transition_to == 'contact' && message.body == Conversation::Bot::POSITIVE_WORD
  end

  def initialize(message)
    @message = message
    @ModelClass = message.class
  end

  def reply
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
