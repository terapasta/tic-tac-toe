class ChatWidgetsController < ApplicationController
  include BotUsable

  def show
    @bot = bots.find(params[:bot_id])
  end
end
