class Chats::MessagesController < ApplicationController
  include Replyable

  before_action :set_chat

  def create
    @message = @chat.messages.build(message_params) { |m| m.speaker = 'guest' }
    @bot_messages = receive_and_reply!(@chat, @message)
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def message_params
      params.require(:message).permit(:answer_id, :body, :context)
    end
end
