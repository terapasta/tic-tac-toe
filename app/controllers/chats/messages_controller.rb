class Chats::MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message_guest = @chat.messages.build(message_params)
    @message_guest.speaker = 'guest'

    responder = Conversation::Switcher.new.responder(@message_guest, session[:states])
    answer = responder.reply
    session[:states] = responder.states

    @chat.context = answer.context
    @message_bot = @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)

    @chat.save!
    @messages = @chat.messages

    Rails.logger.debug(session[:states])
  end

  private
    def set_chat
      @chat = Chat.where(guest_key: session[:guest_key]).last
    end

    def message_params
      params.require(:message).permit(:answer_id, :body, :context)
    end
end
