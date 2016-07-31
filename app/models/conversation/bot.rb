class Conversation::Bot
  attr_accessor :states

  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message)
    @message = message
    @ModelClass = message.class
  end

  def reply
    context = build_context
    Rails.logger.debug("Conversation#reply context: #{context}, body: #{@message.body}")

    answer_id = Ml::Engine.new.reply(context, @message.body)
    answer_id =  Answer::NO_CLASSIFIED_MESSAGE_ID if answer_id.nil?

    Rails.logger.debug("answer_id: #{answer_id}")
    answers = [Answer.find(answer_id)]

    # TODO botクラスにcontactに関係するロジックが混ざっているのでリファクタリングしたい
    if Answer::PRE_TRANSITION_CONTEXT_CONTACT_ID.include?(answer_id) && Service.contact.last.try(:enabled?)
      answers << Answer.find(Answer::TRANSITION_CONTEXT_CONTACT_ID)
    end
    answers
  end

  private
    def build_context
      return [] if NUMBER_OF_CONTEXT < 0
      messages = @ModelClass.where('answer_id is not null').order('id desc').limit(NUMBER_OF_CONTEXT)
      answer_ids = messages.pluck(:answer_id)
      Array.new(NUMBER_OF_CONTEXT).fill(0).concat(answer_ids)[-NUMBER_OF_CONTEXT, NUMBER_OF_CONTEXT]
    end

end
