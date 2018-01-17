module Replyable
  extend ActiveSupport::Concern

  def receive_and_reply!(chat, guest_message)
    reply_response = ReplyRequestService.new(chat.bot, [guest_message.body]).process.first
    bot_message = chat.messages.build(speaker: :bot)

    reply_response.question_answer.tap do |qa|
      bot_message.assign_attributes(
        question_answer_id: qa.id,
        body: qa.answer,
        answer_failed: qa.no_classified?,
        created_at: guest_message.created_at + 1.second,
        reply_log: reply_response.raw_data,
      )
      bot_message.save!

      reply_response.similar_question_answers.tap do |suggests|
        bot_message.similar_question_answers = suggests
        bot_message.update!(
          similar_question_answers_log: suggests.as_json(only: [:question, :answer]),
          is_show_similar_question_answers: reply_response.show_similar_question_answers?
        )
        if suggests.count > 0 && qa.no_classified?
          bot_message.body = chat.bot.render_has_suggests_message(guest_message.body)
          bot_message.update!(answer_failed: false)
        end
      end
    end

    chat.save!
    [bot_message]
  end
end
