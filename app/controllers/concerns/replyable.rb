module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message)
    responder = Conversation::Switcher.new.responder(message, session[:states])
    answers = responder.reply
    session[:states] = responder.states

    reply_messages = answers.map do |answer|
      answer = NullAnswer.new if answer.nil?
      parent.context = answer.context

      body = answer.body
      if answer.no_classified? && parent.is_a?(Chat)
        # 分類出来なかった場合かつ親モデルがChatの場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(parent, parent.bot, message.body)
      end

      parent.messages.build(speaker: 'bot', answer_id: answer.id, body: body)
    end

    parent.save!
    reply_messages
  end

  private
    def auto_mode?
      params[:auto] == '1'
    end
end
