class Api::Bots::Messages::MarksController < Api::BaseController
  before_action :set_bot
  before_action :set_message

  def create
    handle_action(answer_marked: true)
  end

  def destroy
    handle_action(answer_marked: false)
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_message
      @message = @bot.messages.find(params[:message_id])
      authorize @message, :update?
    end

    def handle_action(answer_marked:)
      if @message.update(answer_marked: answer_marked)
        render json: @message, adapter: :json, status: (answer_marked ? :created : :ok)
      else
        render json: { errors: @message.errors.full_messages }, status: :unprocessable_entityt
      end
    end
end
