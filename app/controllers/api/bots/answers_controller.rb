class Api::Bots::AnswersController < Api::BaseController
  before_action :set_bot

  def index
    @answers = @bot.answers.search_by(params[:q])
    render json: @answers, adapter: :json
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end
end
