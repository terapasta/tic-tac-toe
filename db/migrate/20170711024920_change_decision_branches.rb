class ChangeDecisionBranches < ActiveRecord::Migration[4.2]
  def change
    add_column :decision_branches, :question_answer_id, :integer
    add_column :decision_branches, :answer, :text
    add_column :decision_branches, :parent_decision_branch_id, :integer
    add_index :decision_branches, [:question_answer_id, :parent_decision_branch_id], name: :main_decision_branches_index
  end
end
