class Conversation::Contact
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message)
    @message = message
    @last_answer = Message.bot.last.answer
    @contact_state = message.chat.contact_state || message.chat.build_contact_state
    @ModelClass = message.class
  end

  def reply
    case @last_answer.id
    # mofmof inc.に問い合わせ出来るよ。ぼくから送っておこうか？(はい/いいえ)
    # when Answer::TRANSITION_CONTEXT_CONTACT_ID
    #   return Answer.find(Answer::STOP_CONTEXT_ID) if @message.body == NEGATIVE_WORD
    #   return Answer.find(Answer::ASK_GUEST_NAME_ID) if @message.body == POSITIVE_WORD
    # まずは名前を教えて
    when Answer::ASK_GUEST_NAME_ID
      @contact_state.name = @message.body
    # メールアドレスは？
    when 1002
      @contact_state.email = @message.body
    # 用件は？
    when 1003
      @contact_state.body = @message.body
    end

    @contact_state.save!

    if @contact_state.name.blank?
      Answer.find(Answer::ASK_GUEST_NAME_ID)
    elsif @contact_state.email.blank?
      Answer.find(1002)
    elsif @contact_state.body.blank?
      Answer.find(1003)
    else
      Answer.find(1004)
    end
  end
end
