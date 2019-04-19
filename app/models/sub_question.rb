class SubQuestion < ApplicationRecord
  belongs_to :question_answer
  validates :question, presence: true
  validate :check_uniq_question

  def sub_question?
    true
  end

  def check_uniq_question
    unless QuestionAnswer.where(["bot_id = ? and question = ?", question_answer.bot_id, question]).blank?
      errors.add(:question, "既に登録済み")
    end
  end
end
