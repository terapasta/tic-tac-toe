class Conversation::Contact
  attr_accessor :states

  MESSAGES = {
    # mofmof inc.に問い合わせ出来るよ。ぼくから送っておこうか？(はい/いいえ)
    yes_no: Answer::TRANSITION_CONTEXT_CONTACT_ID,
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
    @states = (states || {}).with_indifferent_access
  end

  def reply
    MESSAGES.each do |field, answer_id|
      if answer_id == @last_answer.id
        @states[field] = @message.body
        # TODO 先にYES/NO判定を外側に出す必要がある
        # contact_state = ContactState.new(@states.except(:yes_no))
        # contact_state.chat_id = @message.chat.id
        # unless contact_state.valid?
        #   @states[field] = nil
        #   # TODO エラーメッセージを動的にしたい
        #   return Answer.find(Answer::ASK_ERROR_ID)
        # end
      end
    end

    MESSAGES.each do |field, answer_id|
      if @states[field].blank?
        return Answer.find(answer_id)
      end
    end


    # if @message.chat.contact_states.create!(@states.except(:yes_no))
    # end

    # complete
    Answer.find(Answer::ASK_COMPLETE_ID)
  end
end
