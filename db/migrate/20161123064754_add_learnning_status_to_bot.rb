class AddLearnningStatusToBot < ActiveRecord::Migration
  def change
    add_column :bots, :learning_status, :string
    add_column :bots, :learning_status_changed_at, :datetime
  end
end