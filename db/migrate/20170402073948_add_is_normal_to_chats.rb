class AddIsNormalToChats < ActiveRecord::Migration[4.2]
  def change
    add_column :chats, :is_normal, :boolean, null: false, default: false
    add_index :chats, :is_normal
  end
end
