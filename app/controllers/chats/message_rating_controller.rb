class Chats::MessageRatingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_message
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
    def set_bot_chat_message
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.find_by_guest_key!(session[:guest_key])
      @message = @chat.messages.find(params[:message_id])
    end
end
