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
      answer = NullAnswer.new if answer.nil?
      chat.context = answer.context

      body = answer.body
      if answer.no_classified?
        # 分類出来なかった場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(chat, chat.bot, message.body)
      end

      chat.messages.build(speaker: 'bot', answer_id: answer.id, body: body)
    end

    chat.save!
    reply_messages
  end
end
