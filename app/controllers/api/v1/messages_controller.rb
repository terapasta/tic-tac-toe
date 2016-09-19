class Api::V1::MessagesController < ApplicationController
  include Replyable
  protect_from_forgery with: :null_session

  before_action :set_chat

  def create
    message = @chat.messages.build(body: message_params[:message], speaker: 'guest')
    @reply_messages = receive_and_reply!(@chat, message)
  end

  private
    def set_chat
      @chat = Chat.find_or_create_by(bot_id: message_params[:bot_id], guest_key: message_params[:guest_key]) do |chat|
        chat.guest_key = message_params[:guest_key] || SecureRandom.hex(64)
      end
    end

    def message_params
      params.permit(:bot_id, :guest_key, :message)
    end
end
