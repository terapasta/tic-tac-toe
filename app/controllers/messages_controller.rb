class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def index
    @messages = @chat.messages.page(params[:page])
  end

  private
    def set_chat
      @chat = current_user.bots.find(params[:bot_id]).chats.find(params[:thread_id])
    end
end
