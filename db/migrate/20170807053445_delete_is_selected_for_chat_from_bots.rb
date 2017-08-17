class DeleteIsSelectedForChatFromBots < ActiveRecord::Migration
  def up
    remove_column :bots, :is_selected_for_chat
  end

  def down
    add_column :bots, :is_selected_for_chat, :boolean, default: false
  end
end
