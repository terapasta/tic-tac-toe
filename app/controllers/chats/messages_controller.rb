class Chats::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  # TODO apiの方の実装に統合したい
  def create
    @message_guest = @chat.messages.build(message_params)
    @message_guest.speaker = 'guest'

    responder = Conversation::Switcher.new.responder(@message_guest, session[:states])
    answers = responder.reply
    session[:states] = responder.states

    @bot_messages = answers.map do |answer|
      @chat.context = answer.context
      @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    end

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
