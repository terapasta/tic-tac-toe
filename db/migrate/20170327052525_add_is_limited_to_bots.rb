class AddIsLimitedToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :is_limited, :boolean, default: false
  end
end
