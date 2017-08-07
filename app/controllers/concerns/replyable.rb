module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, message)
    responder = Conversation::Switcher.new.responder(message, session[:states])
    reply = responder.do_reply
    question_answer = reply.question_answer
    # session[:states] = responder.states

    reply_messages = [question_answer].map do |qa|
      body = qa.answer

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

    # HACK questionはreplyが持っているので引数に必要ない？
    def enabled_suggest_question?(reply, parent)
      return false unless parent.is_a?(Chat)
      (reply.probability < Settings.threshold_of_suggest_similar_questions) ||
      (reply.probability < 0.9 && reply.question.length <= 5) ||
      (reply.probability < 0.9 && reply.question_feature_count <= 2)
    end
end
