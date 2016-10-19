class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_chat

  def index
    @messages = @chat.messages.page(params[:page])
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_chat
      @chat = @bot.chats.find(params[:thread_id])
    end
end
