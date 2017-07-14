class ChangeDataTypeBodyFromDecisionBranches < ActiveRecord::Migration
  def up
    change_column :decision_branches, :body, :text, default: nil
  end

  def down
    change_column :decision_branches, :body, :string, null: false, default: ""
  end
end
