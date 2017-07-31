class ChangeDecisionBranchesAnswerIdColumn < ActiveRecord::Migration
  def change
    change_column :decision_branches, :answer_id, :integer, null: true
  end
end
