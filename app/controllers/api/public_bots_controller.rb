class Api::PublicBotsController < Api::BaseController
  skip_before_action :authenticate_user!

  def show
    @bot = Bot.find_by(token: params[:token])
    render json: @bot, adapter: :json, serializer: PublicBotSerializer
  end
end
