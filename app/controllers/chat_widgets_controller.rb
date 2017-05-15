class ChatWidgetsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  def show
    @bot = bots.find(params[:bot_id])
  end
end
