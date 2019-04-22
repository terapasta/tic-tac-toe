class SubQuestionValidator < ActiveModel::Validator
  def validate(record)
    unless QuestionAnswer.where(["bot_id = ? and question = ?", record.question_answer.bot_id, record.question]).blank?
      record.errors.add(:sub_question, "はすでに存在しているか、同じ質問が存在しています。")
    end
  end
end