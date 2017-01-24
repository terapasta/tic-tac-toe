class AddIsStaffToChats < ActiveRecord::Migration
  def change
    add_column :chats, :is_staff, :boolean, default: false
    add_index :chats, :is_staff
  end
end
