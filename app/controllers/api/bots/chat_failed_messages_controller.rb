class Api::Bots::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable

  def create
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
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

    render_collection_json [guest_message, bot_message], status: :created
  end
end