class Conversation::Contact
  attr_accessor :states

  MESSAGES = {
    # まずは名前を教えて
    name: Answer::ASK_GUEST_NAME_ID,
    # メールアドレスは？
    email: Answer::ASK_EMAIL_ID,
    # 用件は？
    body: Answer::ASK_BODY_ID,
  }
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'

  def initialize(message, states = {})
    @message = message
    @last_answer = Message.bot.last.answer
    #@contact_state = message.chat.contact_state || message.chat.build_contact_state
    #@ModelClass = message.class
    @states = (states || {}).with_indifferent_access  # HACK fieldにした方がいいかも
  end

  def reply
    MESSAGES.each do |field, answer_id|
      if answer_id == @last_answer.id
        @states[field] = @message.body
        contact_state = ContactState.new(@states)
        contact_state.chat_id = @message.chat.id
        unless contact_state.valid?
          @states[field] = nil
          # TODO エラーメッセージを動的にしたい
          return [Answer.find(Answer::ASK_ERROR_ID), Answer.find(MESSAGES[field])]
        end
      end
    end

    MESSAGES.each do |field, answer_id|
      if @states[field].blank?
        return [Answer.find(answer_id)]
      end
    end


    # if @message.chat.contact_states.create!(@states.except(:yes_no))
    # end

    # complete
    contact_state = ContactState.new(@states)
    ContactMailer.create(contact_state).deliver_now
    [Answer.find(Answer::ASK_COMPLETE_ID)]
  end
end
