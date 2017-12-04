class Api::Bots::ChatChoicesController < Api::BaseController
  include ApiRespondable
  before_action :set_bot_chat_user_decision_branch!, only: [:create]

  def create
    ActiveRecord::Base.transaction do
      guest_user_message = @chat.messages.create!(guest_message_params)
      @bot_message = @chat.messages.create!(bot_message_params(guest_user_message))
    end
    respond_to do |format|
      format.json { render json: @bot_message, adapter: :json, include: 'child_decision_branches,similar_question_answers' }
    end
  end

  private
    def set_bot_chat_user_decision_branch!
      guest_key = params.require(:guest_key)
      token = params.require(:bot_token)

      @bot = Bot.find_by!(token: token)
      logger.info '---------->'
      logger.info @bot
      @chat_service_user = ChatServiceUser.find_by!(bot: @bot, guest_key: guest_key)
      logger.info '---------->'
      logger.info @chat_service_user
      @chat = @bot.chats.find_by!(guest_key: @chat_service_user.guest_key)
      logger.info '---------->'
      logger.info @chat
      @decision_branch = @chat.bot.decision_branches.find(params[:id])
      logger.info '---------->'
      logger.info @decision_branch
    end

    def guest_message_params
      {
        speaker: 'guest',
        body: @decision_branch.body,
        created_at: @chat.messages.last.created_at + 1.second,
      }
    end

    def bot_message_params(guest_user_message)
      {
        decision_branch_id: @decision_branch.id,
        speaker: 'bot',
        body: @decision_branch.answer.presence || @bot.classify_failed_message.presence || DefinedAnswer.classify_failed_text,
        created_at: guest_user_message.created_at + 1.second,
        answer_failed: @decision_branch.answer.blank?,
      }
    end
end
