class AddIndexesToDumps < ActiveRecord::Migration[5.2]
  def change
    add_index :dumps, :bot_id
    add_index :dumps, :name
  end
end
