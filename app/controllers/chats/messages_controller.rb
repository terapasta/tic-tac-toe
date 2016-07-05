class Chats::MessagesController < ApplicationController
  before_action :set_chat

  def create
    message = @chat.messages.build(message_params)
    message.speaker = 'guest'

    answer = Conversation.new(message).reply
    @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    @chat.save!
    redirect_to chats_path
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def message_params
      params.require(:message).permit(:answer_id, :body)
    end
end
