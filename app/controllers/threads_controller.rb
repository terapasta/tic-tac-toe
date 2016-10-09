class ThreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @chats = @bot.chats.order('id desc').page(params[:page])
  end

  private
    def set_bot
      @bot = current_user.bots.find_by!(id: params[:bot_id])
    end
end
