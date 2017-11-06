class Api::Bots::Chats::MessagesController < Api::BaseController
  skip_before_action :authenticate_user!
  include Replyable
  include ApiRespondable

  def create
    chat_id = params.require(:chat_id)
    token = params.require(:bot_token)
    message = params.require(:message)

    bot = Bot.find_by!(token: token)
    chat = bot.chats.find(chat_id)

    bot_messages = {}
    ActiveRecord::Base.transaction do
      message = chat.messages.create!(body: message) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      bot_messages = receive_and_reply!(chat, message)
    end

    SendAnswerFailedMailService.new(bot_messages, current_user).send_mail
    TaskCreateService.new(bot_messages, bot, current_user).process

    respond_to do |format|
      format.js
      format.json { render_collection_json [message, *bot_messages], include: included_associations }
    end

  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end

  private

  def included_associations
    'question_answer,question_answer.decision_branches,similar_question_answers,question_answer.answer_files'
  end
end
