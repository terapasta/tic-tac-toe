class Admin::Bots::BaseController < ApplicationController
  include BotUsable
  before_action :set_bot

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end
end
