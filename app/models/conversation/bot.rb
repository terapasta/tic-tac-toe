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

    result = Ml::Engine.new(@bot).reply(context, @message.body)
    @results = result['results']

    answer_id = @results.dig(0, 'answer_id')
    probability = @results.dig(0, 'probability')
    Rails.logger.debug(probability)

    if answer_id.present? && probability > 0.6  # TODO 設定ファイルに切り出す
      @answer = Answer.find_by(id: answer_id, type: nil)
    end
    @answer = NullAnswer.new(@bot) if @answer.nil?

    # HACK botクラスにcontactに関係するロジックが混ざっているのでリファクタリングしたい
    # HACK 開発をしやすくするためにcontact機能は一旦コメントアウト
    # if Answer::PRE_TRANSITION_CONTEXT_CONTACT_ID.include?(answer_id) && Service.contact.last.try(:enabled?)
    #   answers << ContactAnswer.find(ContactAnswer::TRANSITION_CONTEXT_CONTACT_ID)
    # end
    [@answer]
  end

  def other_answers
    reply if @results.blank?
    @results
      .select {|data| data['probability'] > 0.001 }
      .map { |data| @bot.answers.find_by(id: data['answer_id']) || DefinedAnswer.find_by(id: data['answer_id']) }
      .select { |answer| answer.try(:headline).try(:present?) && @answer.id != answer.id }[0..4]
  end

  private
    def build_context
      return [] if NUMBER_OF_CONTEXT < 0
      messages = @ModelClass.where('answer_id is not null').order('id desc').limit(NUMBER_OF_CONTEXT)
      answer_ids = messages.pluck(:answer_id)
      Array.new(NUMBER_OF_CONTEXT).fill(0).concat(answer_ids)[-NUMBER_OF_CONTEXT, NUMBER_OF_CONTEXT]
    end

end
