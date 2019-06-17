class SubQuestionValidator < ActiveModel::Validator
  def validate(record)
    if record.question == record.question_answer.question
      record.errors.add(:sub_question, "と同じ質問が存在しています。")
    end

    unless QuestionAnswer.where(["bot_id = ? and question = ?", record.question_answer.bot_id, record.question]).blank?
      record.errors.add(:sub_question, "と同じ質問が存在しています。")
    end

    sub_questions = record.question_answer.sub_questions.map{|rec| rec.question }
    if (sub_questions.count - sub_questions.uniq.count) > 0
      record.errors.add(:sub_question, "と同じサブ質問が存在しています。")
    end


    if SubQuestion.joins(:question_answer)
           .where(question_answers: { bot_id: record.question_answer.bot_id }, sub_questions: { question: record.question })
           .present?
      record.errors.add(:sub_question, "と同じサブ質問が存在しています。")
    end
  end
end