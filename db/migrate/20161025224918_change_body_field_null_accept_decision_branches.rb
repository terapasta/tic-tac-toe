class ChangeBodyFieldNullAcceptDecisionBranches < ActiveRecord::Migration
  def change
    change_column :decision_branches, :body, :string, default: ''
  end
end
