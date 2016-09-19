# HACK 問い合わせ機能は優先度が低いため。他修正の影響による修正を行っていないため正しく動作しない可能性があります。
class Conversation::Contact
  attr_accessor :states

  MESSAGES = {
    # まずは名前を教えて
    name: ContactAnswer::ASK_GUEST_NAME_ID,
    # メールアドレスは？
    email: ContactAnswer::ASK_EMAIL_ID,
    # 用件は？
    body: ContactAnswer::ASK_BODY_ID,
  }
  NUMBER_OF_CONTEXT = 0
  POSITIVE_WORD = 'はい'
  NEGATIVE_WORD = 'いいえ'
  STOP_CONTACT_WORD = 'やめる'

  def initialize(message, states = {})
    @message = message
    @last_answer = Message.bot.last.answer
    #@contact_state = message.chat.contact_state || message.chat.build_contact_state
    #@ModelClass = message.class
    @states = (states || {}).with_indifferent_access  # HACK fieldにした方がいいかも
  end

  def reply
    if @message.body == STOP_CONTACT_WORD
      return [ContactAnswer.find(ContactAnswer::STOP_CONTEXT_ID), Answer.find(Answer::START_MESSAGE_ID)]
    end

    MESSAGES.each do |field, answer_id|
      if answer_id == @last_answer.id
        @states[field] = @message.body
        contact_state = ContactState.new(@states)
        contact_state.chat_id = @message.chat.id
        unless contact_state.valid?
          @states[field] = nil
          # HACK エラーメッセージを動的にしたい
          return [ContactAnswer.find(ContactAnswer::ASK_ERROR_ID), ContactAnswer.find(MESSAGES[field])]
        end
      end
    end

    MESSAGES.each do |field, answer_id|
      if @states[field].blank?
        return [ContactAnswer.find(answer_id)]
      end
    end

    contact_state = ContactState.new(@states)
    if @last_answer.id == ContactAnswer::ASK_CONFIRM_ID
      if @message.body == POSITIVE_WORD
        # complete
        ContactMailer.create(contact_state).deliver_now
        return [ContactAnswer.find(ContactAnswer::ASK_COMPLETE_ID), Answer.find(Answer::START_MESSAGE_ID)]
      elsif @message.body == NEGATIVE_WORD
        return [ContactAnswer.find(ContactAnswer::ASK_GUEST_NAME_ID)]
      end
    end

    answer = ContactAnswer.find(ContactAnswer::ASK_CONFIRM_ID)
    answer.body = answer.body % { values: "お名前: #{contact_state.name}\nメールアドレス: #{contact_state.email}\nご用件: #{contact_state.body}"}
    [answer]
  end
end
