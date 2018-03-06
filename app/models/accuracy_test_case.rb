class AccuracyTestCase < ApplicationRecord
  belongs_to :bot

  validates :question_text, presence: true

  BotMessageStruct = Struct.new(:body, :similar_question_answers)

  def success_result?(bot_message)
    answer_is_success = false
    if expected_text.present?
      answer_is_success = bot_message.body.gsub(/(\s)/, '') == expected_text.gsub(/(\s)/, '')
    end

    # Note: サジェストを期待しない場合はサジェストされたかどうかはチェックしない
    suggestion_is_success = true
    if is_expected_suggestion
      suggestion_is_success = bot_message.similar_question_answers.present?
    end

    answer_is_success && suggestion_is_success
  end

  def success?(reply_response)
    body = if reply_response.is_need_has_suggests_message?
      reply_response.render_has_suggests_message
    else
      reply_response.question_answer.answer
    end
    struct = BotMessageStruct.new(body, reply_response.similar_question_answers)
    success_result?(struct)
  end
end
