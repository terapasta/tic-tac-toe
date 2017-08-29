class Settings::PagesController < ApplicationController
  include BotUsable
  before_action :set_bot

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
