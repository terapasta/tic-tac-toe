class AddNextAnswerIdToDecisionBranches < ActiveRecord::Migration[4.2]
  def change
    add_column :decision_branches, :answer_id, :integer, after: :help_answer_id
    add_column :decision_branches, :next_answer_id, :integer, after: :next_help_answer_id
    add_column :decision_branches, :bot_id, :integer, before: :help_answer_id
  end
end
