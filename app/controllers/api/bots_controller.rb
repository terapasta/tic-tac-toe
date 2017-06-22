class Api::BotsController < Api::BaseController
  def show
    @bot = Bot.find(params[:id])
    authorize @bot
    render json: @bot, adapter: :json
  end
end
