class Api::Bots::ChatworkCredentialsController < Api::BaseController
  def show
    @bot = Bot.find_by(token: params[:bot_token])
    @chatwork_credential = @bot.chatwork_credential
    fail ActiveRecord::RecordNotFound.new if @chatwork_credential.nil?
    render json: @chatwork_credential, adapter: :json
  end
end