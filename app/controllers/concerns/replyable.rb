module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message)
    # TODO pythonに渡す時だけsynonymをwordに差し替える（UIでも変わるのはNG）
    responder = Conversation::Switcher.new.responder(message, session[:states])
    reply = responder.do_reply
    answer = reply.answer
    # session[:states] = responder.states

    reply_messages = [answer].map do |answer|
      parent.context = answer.context

      body = answer.body
      if enabled_chitchat?(answer, parent)
        # 分類出来なかった場合かつ親モデルがChatの場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(parent, parent.bot, message.body)
      end

      message = parent.messages.create!(
        speaker: 'bot',
        answer_id: answer.id || Answer::NO_CLASSIFIED_ID,
        body: body,
        answer_failed: answer.no_classified?,
        created_at: message.created_at + 1.second,
      )
      if responder.present?
        if enabled_suggest_question?(reply, parent)
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

    # HACK questionはreplyが持っているので引数に必要ない？
    def enabled_suggest_question?(reply, parent)
      return false unless parent.is_a?(Chat) && parent.bot.has_feature?(:suggest_question)
      (reply.probability < Settings.threshold_of_suggest_similar_questions) ||
      (reply.probability < 0.9 && reply.question.length <= 5) ||
      (reply.probability < 0.9 && reply.question_feature_count <= 2)
    end
end
