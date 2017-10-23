class AddIsStaffToChats < ActiveRecord::Migration[4.2]
  def change
    add_column :chats, :is_staff, :boolean, default: false
    add_index :chats, :is_staff
  end
end
