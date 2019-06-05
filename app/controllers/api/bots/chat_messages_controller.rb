class Api::Bots::ChatMessagesController < Api::BaseController
  include Replyable
  include ApiRespondable
  include ApiChatOperable
  include ResourceSerializable

  def index
    guest_key = params.require(:guest_key)
    token = params.require(:bot_token)
    bot = Bot
      .eager_load(initial_selections: [:question_answer])
      .find_by!(token: token)
    chat = bot.chats.find_by!(guest_key: guest_key)
    first_id = Message
      .select(:id)
      .order(created_at: :desc)
      .where(chat_id: chat.id)
      .first
      &.id

    per_page = params[:per_page].presence || 50

    scoped_messages = chat.messages
      .includes(:rating, chat: [:bot], question_answer: [:decision_branches, :answer_files])
      .order(created_at: :desc)

    if params[:older_than_id].present?
      if params[:older_than_id].to_i.zero?
        messages = scoped_messages.limit(per_page)
      else
        messages = scoped_messages
          .where('id < ?', params[:older_than_id])
          .limit(per_page)
      end
    else
      messages = scoped_messages
        .page(params[:page])
        .per(per_page)
    end

    messages.detect{ |it| it.id === first_id }.tap do |first|
      if first.present?
        first.initial_selections = bot.initial_selections
      end
    end

    respond_to do |format|
      format.json do
        if params[:older_than_id].present? && messages.last.present?
          headers['X-Next-Page-Exists'] = scoped_messages
            .where('id < ?', messages.last.id)
            .count > 0
        else
          headers['X-Current-Page'] = messages.current_page
          headers['X-Total-Pages'] = messages.total_pages
        end
        render json: messages, adapter: :json, include: included_associations
      end
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
