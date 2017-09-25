class Chats::MessageRatingController < ApplicationController
  include GuestKeyUsable
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_message

  def good
    @message.good!
    render json: @message, adapter: :json
  end

  def bad
    @message.bad!
    SendBadRateMailService.new(@message, current_user).send_mail
    TaskCreateService.new(@message, @bot).process
    render json: @message, adapter: :json
  end

  def nothing
    @message.nothing!
    render json: @message, adapter: :json
  end

  private
    def set_bot_chat_message
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.find_by_guest_key!(guest_key)
      @message = @chat.messages.find(params[:message_id])
    end
end
