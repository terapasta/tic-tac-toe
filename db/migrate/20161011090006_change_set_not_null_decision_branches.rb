class ChangeSetNotNullDecisionBranches < ActiveRecord::Migration
  def change
    DecisionBranch.where(answer_id: nil).destroy_all
    DecisionBranch.where(bot_id: nil).destroy_all
    change_column :decision_branches, :answer_id, :integer, null: false
    change_column :decision_branches, :bot_id, :integer, null: false
    add_index :decision_branches, :answer_id
    add_index :decision_branches, :bot_id
  end
end
