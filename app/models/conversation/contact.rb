class Conversation::Contact
  attr_accessor :states

  FIELDS = {
    # mofmof inc.に問い合わせ出来るよ。ぼくから送っておこうか？(はい/いいえ)
    yes_no: Answer::TRANSITION_CONTEXT_CONTACT_ID,
    name: 29,
    email: 30,
    body: 31,
  }
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message, states = {})
    @message = message
    @last_answer = Message.bot.last.answer
    @contact_state = message.chat.contact_state || message.chat.build_contact_state
    @ModelClass = message.class
    @states = states || {}
  end

  def reply
    FIELDS.each do |field, answer_id|
      if answer_id == @last_answer.id
        @states[field.to_s] = @message.body
      #   if @message.body == NEGATIVE_WORD
      #     @states[field] = false
      #   elsif @message.body == POSITIVE_WORD
      #     @states[field] = true
      #   end
      end
      # if @states[field].blank?
      #   return Answer.find(answer_id)
      # end
    end

    FIELDS.each do |field, answer_id|
      if @states[field.to_s].blank?
        return Answer.find(answer_id)
      end
    end

    # complete
    Answer.find(32)

    # case @last_answer.id
    # # mofmof inc.に問い合わせ出来るよ。ぼくから送っておこうか？(はい/いいえ)
    # when Answer::TRANSITION_CONTEXT_CONTACT_ID
    #   return Answer.find(Answer::STOP_CONTEXT_ID) if @message.body == NEGATIVE_WORD
    #   return Answer.find(Answer::ASK_GUEST_NAME_ID) if @message.body == POSITIVE_WORD
    # # まずは名前を教えて
    # when 29
    #   @contact_state.name = @message.body
    # # メールアドレスは？
    # when 30
    #   @contact_state.email = @message.body
    # # 用件は？
    # when 31
    #   @contact_state.body = @message.body
    # end
    #
    # @contact_state.save!
    #
    # if @contact_state.name.blank?
    #   Answer.find(29)
    # elsif @contact_state.email.blank?
    #   Answer.find(30)
    # elsif @contact_state.body.blank?
    #   Answer.find(31)
    # else
    #   Answer.find(32)
    # end
  end

  # class State
  #   FIELDS = %w( name email body )
  #   FIELDS.each do |field|
  #     attr_accessor field
  #   end
  # end
end
