class Chats::MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message_guest = @chat.messages.build(message_params)
    @message_guest.speaker = 'guest'

    answer = Conversation.new(@message_guest).reply
    @message_bot = @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    @message_bot.context = 'contact' if answer.id == Answer::TRANSITION_CONTEXT_CONTACT_ID

    @chat.save!
    @messages = @chat.messages
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def message_params
      params.require(:message).permit(:answer_id, :body, :context)
    end
end
