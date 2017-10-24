class AddAnswerToQuestionAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :question_answers, :answer, :text
  end
end
