class Settings::BaseController < ApplicationController
  include BotUsable
  include Pundit
  before_action :authenticate_user!
  before_action :set_bot

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end
end
