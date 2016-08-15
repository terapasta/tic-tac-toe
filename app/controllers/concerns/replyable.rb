module Replyable
  extend ActiveSupport::Concern

  # included do
  #   scope :disabled, -> { where(disabled: true) }
  # end

  # class_methods do
  #   ...
  # end
  def receive_and_reply!(chat, message)
    responder = Conversation::Switcher.new.responder(message, session[:states])
    answers = responder.reply
    session[:states] = responder.states

    reply_messages = answers.map do |answer|
      chat.context = answer.context
      chat.messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    end

    chat.save!
    reply_messages
  end
end
