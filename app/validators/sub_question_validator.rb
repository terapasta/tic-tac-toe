class SubQuestionValidator < ActiveModel::Validator
  def validate(record)
    if record.question == record.question_answer.question
      record.errors.add(:sub_question, "と同じ質問が存在しています。")
    end

    puts ("record #{record}")

    if SubQuestion.joins(:question_answer)
           .where({question_answers: { bot_id: record.question_answer.bot_id }, sub_questions: { question: record.question } })
           .present?
      record.errors.add(:sub_question, "と同じサブ質問が存在しています。")
    end
  end
end