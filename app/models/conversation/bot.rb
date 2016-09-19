class Conversation::Bot
  attr_accessor :states

  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(bot, message)
    @bot = bot
    @message = message
    @ModelClass = message.class
  end

  def reply
    context = build_context
    Rails.logger.debug("Conversation#reply context: #{context}, body: #{@message.body}")

    result = Ml::Engine.new(@bot.id).reply(context, @message.body)
    Rails.logger.debug("answer_id: #{result['answer_id']}")

    answers =
      if result['answer_id'].present?
        [Answer.find(result['answer_id'])]
      else
        [@bot.no_classified_answer]
      end

    # HACK botクラスにcontactに関係するロジックが混ざっているのでリファクタリングしたい
    # HACK 開発をしやすくするためにcontact機能は一旦コメントアウト
    # if Answer::PRE_TRANSITION_CONTEXT_CONTACT_ID.include?(answer_id) && Service.contact.last.try(:enabled?)
    #   answers << ContactAnswer.find(ContactAnswer::TRANSITION_CONTEXT_CONTACT_ID)
    # end
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
