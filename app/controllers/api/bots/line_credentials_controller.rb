class Api::Bots::LineCredentialsController < Api::BaseController
  def show
    @bot = Bot.find_by(token: params[:bot_token])
    @line_credential = @bot.line_credential
    fail ActiveRecord::RecordNotFound.new if @line_credential.nil?
    render json: @line_credential, adapter: :json
  end
end