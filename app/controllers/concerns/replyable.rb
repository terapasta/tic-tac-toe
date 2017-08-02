module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message)
    responder = Conversation::Switcher.new.responder(message, session[:states])
    reply = responder.do_reply
    question_answer = reply.question_answer
    # session[:states] = responder.states

    reply_messages = [question_answer].map do |qa|
      body = qa.answer
      if enabled_chitchat?(qa, parent)
        # 分類出来なかった場合かつ親モデルがChatの場合、Docomoの雑談APIを使って返す
        body = DocomoClient.new.reply(parent, parent.bot, message.body)
      end

      message = parent.messages.create!(
        speaker: 'bot',
        question_answer_id: qa.id,
        body: body,
        answer_failed: qa.no_classified?,
        created_at: message.created_at + 1.second,
      )
      if responder.present?
        if enabled_suggest_question?(reply, parent)
          message.similar_question_answers = responder.similar_question_answers_in(reply.question_answer_ids).compact
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

    def enabled_chitchat?(question_answer, parent)
      question_answer.no_classified? &&
      parent.is_a?(Chat) &&
      parent.bot.has_feature?(:chitchat)
    end

    # HACK questionはreplyが持っているので引数に必要ない？
    def enabled_suggest_question?(reply, parent)
      return false unless parent.is_a?(Chat)
      (reply.probability < Configs.threshold_of_suggest_similar_questions) ||
      (reply.probability < 0.9 && reply.question.length <= 5) ||
      (reply.probability < 0.9 && reply.question_feature_count <= 2)
    end
end
