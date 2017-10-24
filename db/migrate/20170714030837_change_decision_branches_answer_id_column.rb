class ChangeDecisionBranchesAnswerIdColumn < ActiveRecord::Migration[4.2]
  def change
    change_column :decision_branches, :answer_id, :integer, null: true
  end
end
