class AddAnswerToQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :question_answers, :answer, :text
  end
end
