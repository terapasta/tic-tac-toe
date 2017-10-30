class AddQuestionAnswerIdToAnswerFiles < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_files, :question_answer_id, :integer
    add_index :answer_files, [:question_answer_id]
  end
end
