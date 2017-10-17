class AddDecisionBranchIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :decision_branch_id, :integer
  end
end
