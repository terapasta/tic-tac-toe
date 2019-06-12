class SubQuestionValidator < ActiveModel::Validator
  def validate(record)
    if record.question == record.question_answer.question
      record.errors.add(:sub_question, "と同じ質問が存在しています。")
    end
    sub_questions = record.question_answer.sub_questions.map{|rec| rec.question }

    unless sub_questions.uniq.map{|e| [e, sub_questions.count(e)]}.select{|_, i| i > 1}.empty?
      record.errors.add(:sub_question, "と同じサブ質問が存在しています。")
    end


    if SubQuestion.joins(:question_answer)
           .where({question_answers: { bot_id: record.question_answer.bot_id }, sub_questions: { question: record.question } })
           .present?
      record.errors.add(:sub_question, "と同じサブ質問が存在しています。")
    end
  end
end