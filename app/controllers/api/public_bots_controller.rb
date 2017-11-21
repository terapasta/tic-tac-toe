class Api::PublicBotsController < Api::BaseController
  before_action :set_carrierwave_asset_host
  after_action :remove_carrierwave_asset_host

  def show
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'GET,HEAD'
    @bot = Bot.find_by(token: params[:token])
    render json: { error: 'not found' }, status: :not_found and return if @bot.nil?
    authorize @bot.chats.build, :new?
    render json: @bot, adapter: :json, serializer: PublicBotSerializer
  end

  private
    def set_carrierwave_asset_host
      return unless Rails.env.development?
      CarrierWave.configure do |config|
        config.asset_host = "#{request.scheme}://#{request.host}"
      end
    end

    def remove_carrierwave_asset_host
      return unless Rails.env.development?
      CarrierWave.configure do |config|
        config.asset_host = nil
      end
    end
end
