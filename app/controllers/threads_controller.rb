class ThreadsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @chats = @bot.chats.has_multiple_messages.page(params[:page])
    @chats = @chats.not_staff unless current_user.staff?
    @chats = @chats.has_answer_failed if params[:filter].present?
  end

  private
    def set_bot
      @bot = bots.find_by!(id: params[:bot_id])
    end
end
