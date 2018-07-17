class AddRoomIdAndFromAccountIdToChatworkDecisionBranches < ActiveRecord::Migration[5.1]
  def change
    add_column :chatwork_decision_branches, :room_id, :string, null: false
    add_column :chatwork_decision_branches, :from_account_id, :string, null: false
  end
end
