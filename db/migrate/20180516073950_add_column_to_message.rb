class AddColumnToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :guest_message_id, :integer
  end
end
