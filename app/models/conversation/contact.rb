class Conversation::Contact
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message)
    @message = message
    @last_answer_message = Message.bot.last
    @contact_state = message.chat.contact_state || message.chat.build_contact_state
    @ModelClass = message.class
  end

  def reply
    return Answer.find(Answer::STOP_CONTEXT_ID) if @message.body == NEGATIVE_WORD
    return Answer.find(Answer::ASK_GUEST_NAME_ID) if @message.body == POSITIVE_WORD

    # %w(name email body).each do |field|
    #   if @contact_state.
    # end
    case @last_answer_message.answer.id
    when 29
      @contact_state.name = @message.body
    when 30
      @contact_state.email = @message.body
    when 31
      @contact_state.body = @message.body
    end

    @contact_state.save!

    if @contact_state.name.blank?
      Answer.find(29)
    elsif @contact_state.email.blank?
      Answer.find(30)
    elsif @contact_state.body.blank?
      Answer.find(31)
    else
      Answer.find(32)
    end
  end
end
