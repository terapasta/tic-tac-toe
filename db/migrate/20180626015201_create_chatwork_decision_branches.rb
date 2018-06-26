class CreateChatworkDecisionBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :chatwork_decision_branches do |t|
      t.integer :chat_id, null: false
      t.string :access_token, null: false
      t.integer :decision_branch_id, null: false

      t.index [:access_token], unique: true
      t.timestamps
    end
  end
end
