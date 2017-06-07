class Chats::MessageRatingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat_message

  def good
    @message.good!
    render json: @message, adapter: :json
  end

  def bad
    @message.bad!
    @task = Task.new
    @task.set_task(@task, @bot.id, @chat, params[:message_id].to_i, params[:action])
    SendBadRateMailService.new(@message, current_user).send_mail
    render json: @message, adapter: :json
  end

  def nothing
    @message.nothing!
    binding.pry
    render json: @message, adapter: :json
  end

  private
    def set_bot_chat_message
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.find_by_guest_key!(session[:guest_key])
      @message = @chat.messages.find(params[:message_id])
    end
end
