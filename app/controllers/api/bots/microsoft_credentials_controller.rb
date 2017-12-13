class Api::Bots::MicrosoftCredentialsController < Api::BaseController
  def show
    @bot = Bot.find_by!(token: params[:bot_token])
    @microsoft_credential = @bot.microsoft_credential
    fail ActiveRecord::RecordNotFound.new if @microsoft_credential.nil?
    render json: @microsoft_credential, adapter: :json
  end
end