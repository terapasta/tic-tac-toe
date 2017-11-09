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
        responder.similar_question_answers_in(reply.question_answer_ids).compact.tap do |suggests|
          bot_message.similar_question_answers = suggests
          bot_message.update!(
            similar_question_answers_log: suggests.as_json(only: [:question, :answer]),
            is_show_similar_question_answers: show_similar_question_answers?(reply)
          )
          if suggests.count > 0 && qa.no_classified?
            bot_message.body = parent.bot.render_has_suggests_message(guest_message.body)
            bot_message.update!(answer_failed: false)
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

    def show_similar_question_answers?(reply)
      reply.probability < MyOpeConfig.threshold_of_suggest_similar_questions ||
      (reply.probability < 0.9 && reply.question.length <= 5) ||
      (reply.probability < 0.9 && reply.question_feature_count <= 2)
    end
end
