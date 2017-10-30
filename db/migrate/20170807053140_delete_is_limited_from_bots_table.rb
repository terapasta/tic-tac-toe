class DeleteIsLimitedFromBotsTable < ActiveRecord::Migration[4.2]
  def up
    remove_column :bots, :is_limited
  end

  def down
    add_column :bots, :is_limited, :boolean, default: false
  end
end
