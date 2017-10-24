class ChangeBodyFieldNullAcceptDecisionBranches < ActiveRecord::Migration[4.2]
  def change
    change_column :decision_branches, :body, :string, default: ''
  end
end
