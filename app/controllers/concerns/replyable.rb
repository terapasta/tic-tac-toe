module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message, other_answer_id = nil)
    question = message.body
    if other_answer_id.present?
      answer = parent.bot.answers.find(other_answer_id)
    else
      responder = Conversation::Switcher.new.responder(message, session[:states])
      reply = responder.do_reply
      answer = reply.answer
    end
    # session[:states] = responder.states

    reply_messages = [answer].map do |answer|
      parent.context = answer.context

      body = answer.body
      if enabled_chitchat?(answer, parent)
        # 分類出来なかった場合かつ親モデルがChatの場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(parent, parent.bot, message.body)
      end

      message = parent.messages.build(speaker: 'bot', answer_id: answer.id || Answer::NO_CLASSIFIED_ID, body: body, answer_failed: answer.no_classified?)
      if responder.present?
        message.other_answers = responder.other_answers

        if enabled_suggest_question?(question, answer, parent)
          message.similar_question_answers = responder.similar_question_answers
        end
      end
      message
    end

    parent.save!
    reply_messages
  end

  private
    def auto_mode?
      params[:auto] == '1'
    end

    def enabled_chitchat?(answer, parent)
      answer.no_classified? &&
      parent.is_a?(Chat) &&
      parent.bot.has_feature?(:chitchat)
    end

    def enabled_suggest_question?(question, answer, parent)
      return false unless parent.is_a?(Chat) && parent.bot.has_feature?(:suggest_question)
      (answer.probability < Settings.threshold_of_suggest_similar_questions) ||
      (answer.probability < 0.9 && question.length <= 5)
    end
end
