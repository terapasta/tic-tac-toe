class AccuracyTestCase < ApplicationRecord
  belongs_to :bot

  validates :question_text, presence: true

  def success_result?(bot_messages)
    success = false
    if expected_text.present?
      success = bot_messages.map{ |m| m.body.gsub(/(\s)/, '') }.any? { |b| b == expected_text.gsub(/(\s)/, '') }
    end
    if is_expected_suggestion
      success = bot_messages.any?{ |m| m.similar_question_answers.present? }
    end
    success
  end
end
