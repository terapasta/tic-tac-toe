class MessagesController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_chat

  def index
    @per_page = 20
    @messages = @chat.messages.page(params[:page]).per(@per_page)
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def set_chat
      @chat = @bot.chats.find(params[:thread_id])
    end
end
