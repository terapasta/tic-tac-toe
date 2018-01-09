class AddChatTestResultsToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :chat_test_results, :text
    add_column :bots, :is_chat_test_processing, :boolean
  end
end
