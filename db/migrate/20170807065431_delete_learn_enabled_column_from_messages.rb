class DeleteLearnEnabledColumnFromMessages < ActiveRecord::Migration[4.2]
  def up
    remove_column :messages, :learn_enabled
  end

  def down
    dd_column :messages, :learn_enabled, :boolean, default: true, null: false
  end
end
