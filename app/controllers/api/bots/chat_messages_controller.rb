class Api::Bots::ChatMessagesController < Api::BaseController
  include Replyable
  include ApiRespondable
  include ApiChatOperable
  include ResourceSerializable

  def index
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
    bot = Bot.find_by!(token: token)
    chat = bot.chats.find_by!(guest_key: guest_key)
    messages = chat.messages
      .includes(:rating, chat: [:bot], question_answer: [:decision_branches, :answer_files])
      .order(created_at: :desc)
      .page(params[:page])
      .per(params[:per_page].presence || 50)

    respond_to do |format|
      format.json { render json: messages, adapter: :json, include: included_associations }
    end
  end

  def create
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
    message = params[:message]
    question_answer_id = params[:question_answer_id]

    bot = Bot.find_by!(token: token)
    chat_service_user = find_chat_service_user!(bot, guest_key)
    chat = bot.chats.find_by!(guest_key: guest_key)

    if message.blank? && question_answer_id.present?
      message = bot.question_answers.find(question_answer_id).question
    end

    bot_messages = {}
    ActiveRecord::Base.transaction do
      message = chat.messages.create!(body: message) {|m|
        m.speaker = 'guest'
        m.user_agent = request.env['HTTP_USER_AGENT']
      }
      ChatChannel.broadcast_to(chat, { action: :create, data: serialize(message) })
      bot_messages = receive_and_reply!(chat, message)
    end

    TaskCreateService.new(bot_messages, bot, nil).process.each do |task, bot_message|
      unless chat_service_user.try(:line?)
        SendAnswerFailedMailService.new(bot_message, nil, task).send_mail
      end
    end

    respond_to do |format|
      format.json { render json: bot_messages.first, adapter: :json, include: included_associations }
    end

    ChatChannel.broadcast_to(chat, {
      action: :create,
      data: serialize(bot_messages.first, include: included_associations)
    })

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
