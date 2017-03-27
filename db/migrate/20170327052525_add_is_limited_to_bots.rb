class AddIsLimitedToBots < ActiveRecord::Migration
  def change
    add_column :bots, :is_limited, :boolean, default: false
  end
end
