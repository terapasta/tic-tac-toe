class AddBotMessageIdAndGuestMessageIdToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :bot_message_id, :integer
    add_column :tasks, :guest_message_id, :integer
  end
end
