module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(parent, guest_message)
    responder = Conversation::Switcher.new.responder(guest_message, session[:states])
    reply = responder.do_reply
    question_answer = reply.question_answer
    # session[:states] = responder.states

    bot_messages = [question_answer].map do |qa|
      body = qa.answer

      bot_message = parent.messages.create!(
        speaker: 'bot',
        question_answer_id: qa.id,
        body: body,
        answer_failed: qa.no_classified?,
        created_at: guest_message.created_at + 1.second,
      )
      if responder.present?
        if enabled_suggest_question?(reply, parent)
          responder.similar_question_answers_in(reply.question_answer_ids).compact.tap do |suggests|
            bot_message.similar_question_answers = suggests
            if suggests.count > 0 && qa.no_classified?
              bot_message.body = parent.bot.render_has_suggests_message(guest_message.body)
            end
          end
        end
      end
      bot_message
    end

    parent.save!
    bot_messages
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
