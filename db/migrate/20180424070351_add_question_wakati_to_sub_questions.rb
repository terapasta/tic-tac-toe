class AddQuestionWakatiToSubQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :sub_questions, :question_wakati, :text
  end
end
