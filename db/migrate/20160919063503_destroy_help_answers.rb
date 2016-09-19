class DestroyHelpAnswers < ActiveRecord::Migration
  def change
    drop_table :help_answers
    drop_table :training_help_messages
    remove_column :decision_branches, :help_answer_id
    remove_column :decision_branches, :next_help_answer_id
  end
end
