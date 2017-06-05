class AddSelectableQuestion < ActiveRecord::Migration
  def change
    add_column :bots, :is_selected_for_chat, :boolean, default: false
  end
end
