class Api::Bots::SlackCredentialsController < ApplicationController
  def show
    @bot = Bot.find_by!(token: params[:bot_token])
    @slack_credential = @bot.slack_credential
    fail ActiveRecord::RecordNotFound.new if @slack_credential.nil?
    render json: @slack_credential, adapter: :json
  end
end
