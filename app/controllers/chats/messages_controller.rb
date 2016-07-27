class Chats::MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message_guest = @chat.messages.build(message_params)
    @message_guest.speaker = 'guest'

    answer = Conversation::Bot.responder(@message_guest).reply
    @message_bot = @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    #@chat.context = 'contact' if context_contact?(answer)
    @chat.context = nil if Answer::STOP_CONTEXT_ID == answer.id
    @chat.context = nil if Answer::COMPLETE_CONTACT_ID == answer.id

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

    # def context_contact?(answer)
    #   # [ Answer::TRANSITION_CONTEXT_CONTACT_ID, Answer::ASK_GUEST_NAME_ID ].include?(answer.id)
    #   [ Answer::TRANSITION_CONTEXT_CONTACT_ID ].include?(answer.id)
    # end
end
