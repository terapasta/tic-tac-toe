class AddDecisionBranchIdToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :decision_branch_id, :integer
  end
end
