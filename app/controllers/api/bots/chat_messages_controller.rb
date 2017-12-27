class Api::Bots::ChatMessagesController < Api::BaseController
  include Replyable
  include ApiRespondable

  def create
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
    message = params[:message]
    question_answer_id = params[:question_answer_id]

    bot = Bot.find_by!(token: token)
    chat_service_user = bot.chat_service_users.find_by!(guest_key: guest_key)
    chat = bot.chats.find_by!(guest_key: chat_service_user.guest_key)

    if message.blank? && question_answer_id.present?
      message = bot.question_answers.find(question_answer_id).question
    end

    bot_messages = {}
    ActiveRecord::Base.transaction do
      message = chat.messages.create!(body: message) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      bot_messages = receive_and_reply!(chat, message)
    end

    TaskCreateService.new(bot_messages, bot, nil).process.each do |task, bot_message|
      SendAnswerFailedMailService.new(bot_message, nil, task).send_mail
    end

    respond_to do |format|
      format.json { render json: bot_messages.first, adapter: :json, include: included_associations }
    end

  rescue Ml::Engine::NotTrainedError => e
    logger.error e.message + e.backtrace.join("\n")
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :service_unavailable }
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
