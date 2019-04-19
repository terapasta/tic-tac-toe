module NotApplicableMessageHandleable
  extend ActiveSupport::Concern

  def create_messages_for_failed
    guest_key = params.require(:guest_key)
    # Web版（chats)と外部連携API（api/bots)とでtokenの取り方が違うため条件分岐
    token = params[:token].present? ? params.require(:token) : params.require(:bot_token)
    message = params.require(:message)

    bot = Bot.find_by!(token: token)
    chat = bot.chats.find_by!(guest_key: guest_key)

    null_question_answer = NullQuestionAnswer.new(bot)

    guest_message = chat.messages.create(
      speaker: :guest,
      body: message,
      user_agent: request.user_agent
    )
    bot_message = chat.messages.create(
      speaker: :bot,
      body: null_question_answer.answer,
      answer_failed: true,
      question_answer_id: null_question_answer.id,
      guest_message_id: guest_message.id
    )
    return [guest_message, bot_message]
  end
end
