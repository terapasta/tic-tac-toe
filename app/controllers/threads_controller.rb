class ThreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @chats = @bot.chats.includes(:messages).order('chats.id desc').page(params[:page])
    @chats = @chats.where('messages.answer_failed', true).references(:messages) if params[:filter].present?
  end

  private
    def set_bot
      @bot = current_user.bots.find_by!(id: params[:bot_id])
    end
end
