class AddLearnEnabledTrainingMessages < ActiveRecord::Migration
  def change
    add_column :training_messages, :learn_enabled, :boolean, after: :body, null: false, default: 1
  end
end
