module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message, other_answer_id = nil)
    if other_answer_id.present?
      answer = parent.bot.answers.find(other_answer_id)
      answers = [answer]
    else
      responder = Conversation::Switcher.new.responder(message, session[:states])
      answers = responder.reply
    end
    # session[:states] = responder.states

    reply_messages = answers.map do |answer|
      parent.context = answer.context

      body = answer.body
      if answer.no_classified? && parent.is_a?(Chat) && parent.bot.has_feature?(:chitchat)
        # 分類出来なかった場合かつ親モデルがChatの場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(parent, parent.bot, message.body)
      end

      message = parent.messages.build(speaker: 'bot', answer_id: answer.id, body: body, answer_failed: answer.is_a?(NullAnswer))
      message.other_answers = responder.other_answers if responder.present?
      message
    end

    parent.save!
    reply_messages
  end

  private
    def auto_mode?
      params[:auto] == '1'
    end
end
