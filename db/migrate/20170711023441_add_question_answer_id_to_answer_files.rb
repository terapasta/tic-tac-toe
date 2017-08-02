class AddQuestionAnswerIdToAnswerFiles < ActiveRecord::Migration
  def change
    add_column :answer_files, :question_answer_id, :integer
    add_index :answer_files, [:question_answer_id]
  end
end
