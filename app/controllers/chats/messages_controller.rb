class Chats::MessagesController < ApplicationController
  include Replyable
  skip_before_action :verify_authenticity_token
  before_action :set_bot_chat

  def create
    @bot = Bot.find_by!(token: params[:token])
    @message = @chat.messages.build(message_params) {|m|
      m.speaker = 'guest'
      m.user_agent = request.env['HTTP_USER_AGENT']
    }
    @bot_messages = receive_and_reply!(@chat, @message, params[:message][:other_answer_id])
  end

  private
    def set_bot_chat
      @bot = Bot.find_by!(token: params[:token])
      @chat = @bot.chats.where(guest_key: session[:guest_key]).last
    end

    def message_params
      params.require(:message).permit(:answer_id, :body)
    end
end
