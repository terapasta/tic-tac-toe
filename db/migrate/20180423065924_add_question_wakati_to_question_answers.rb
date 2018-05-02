class AddQuestionWakatiToQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :question_answers, :question_wakati, :text
  end
end
