class AddLearnEnabledTrainingMessages < ActiveRecord::Migration
  def change
    add_column :training_messages, :learn_enabled, :boolean, after: :body, null: false, default: 1
    add_column :messages, :learn_enabled, :boolean, after: :user_agent, null: false, default: 1
  end
end
