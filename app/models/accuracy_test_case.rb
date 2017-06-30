class AccuracyTestCase < ActiveRecord::Base
  belongs_to :bot

  validates :question_text, presence: true

  def success_result?(bot_messages)
    success = false
    if expected_text.present?
      success = bot_messages.select{ |m| m.body != expected_text }.blank?
    end
    if is_expected_suggestion
      success = bot_messages.select{ |m| m.similar_question_answers.blank? }.blank?
    end
    success
  end
end
