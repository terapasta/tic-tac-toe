class AddIsNormalToChats < ActiveRecord::Migration
  def change
    add_column :chats, :is_normal, :boolean, null: false, default: false
    add_index :chats, :is_normal
  end
end
