class Chats::MessageRatingController < ApplicationController
  before_action :set_chat
  before_action :set_message

  respond_to :json

  def good
    @message.good!
    respond_with @message
  end

  def bad
    @message.bad!
    respond_with @message
  end

  def nothing
    @message.nothing!
    respond_with @message
  end

  private
    def set_chat
      @chat = Chat.find_by_guest_key!(session[:guest_key])
    end

    def set_message
      @message = @chat.messages.find(params[:message_id])
    end
end
