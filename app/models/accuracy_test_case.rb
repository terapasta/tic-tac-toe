class AccuracyTestCase < ApplicationRecord
  belongs_to :bot

  validates :question_text, presence: true

  def success_result?(bot_messages)
    answer_is_success = false
    if expected_text.present?
      answer_is_success = bot_messages.map{ |m| m.body.gsub(/(\s)/, '') }.any? { |b| b == expected_text.gsub(/(\s)/, '') }
    end

    # Note: サジェストを期待しない場合はサジェストされたかどうかはチェックしない
    suggestion_is_success = true
    if is_expected_suggestion
      suggestion_is_success = bot_messages.any?{ |m| m.similar_question_answers.present? }
    end
    answer_is_success and suggestion_is_success
  end
end
