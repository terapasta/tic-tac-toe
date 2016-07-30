class Api::V1::MessagesController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_chat

  def create
    message = @chat.messages.build(body: message_params[:message], speaker: 'guest')
    responder = Conversation::Switcher.new.responder(message, session[:states])
    answers = responder.reply
    session[:states] = responder.states

    @reply_messages = answers.map do |answer|
      @chat.context = answer.context
      @chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    end

    @chat.save!
  end

  private
    def set_chat
      @chat = Chat.find_by(guest_key: message_params[:guest_key])
      @chat ||= Chat.create(guest_key: SecureRandom.hex(64))
    end

    def message_params
      params.permit(:guest_key, :message)
    end
end
