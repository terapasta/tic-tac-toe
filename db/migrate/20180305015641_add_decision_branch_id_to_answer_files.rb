class AddDecisionBranchIdToAnswerFiles < ActiveRecord::Migration[5.1]
  def change
    add_column :answer_files, :decision_branch_id, :integer
  end
end
