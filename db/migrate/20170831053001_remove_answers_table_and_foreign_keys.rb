class RemoveAnswersTableAndForeignKeys < ActiveRecord::Migration[4.2]
  def change
    drop_table :answers
    remove_column :answer_files, :answer_id, :integer

    remove_column :decision_branches, :answer_id, :integer
    remove_column :decision_branches, :next_answer_id, :integer

    remove_column :learning_training_messages, :answer_id, :integer

    remove_column :messages, :answer_id, :integer

    remove_column :question_answers, :answer_id, :integer
  end
end
