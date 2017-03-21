class AnswerFailedToZero < ActiveRecord::Migration
  def change
    defined_answer = DefinedAnswer.classify_failed
    return if defined_answer.blank?
    ActiveRecord::Base.transaction do
      DecisionBranch.where(answer_id: defined_answer.id).update_all(answer_id: Answer::NO_CLASSIFIED_ID)
      DecisionBranch.where(next_answer_id: defined_answer.id).update_all(next_answer_id: Answer::NO_CLASSIFIED_ID)
      LearningTrainingMessage.where(answer_id: defined_answer.id).update_all(answer_id: Answer::NO_CLASSIFIED_ID)
      Message.where(answer_id: defined_answer.id).update_all(answer_id: Answer::NO_CLASSIFIED_ID)
      QuestionAnswer.where(answer_id: defined_answer.id).update_all(answer_id: Answer::NO_CLASSIFIED_ID)
      TrainingMessage.where(answer_id: defined_answer.id).update_all(answer_id: Answer::NO_CLASSIFIED_ID)
      Answer.where(id: defined_answer.id).update_all(id: Answer::NO_CLASSIFIED_ID)
    end
  end
end
