class ChangeBotChatTestResultsColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :bots, :chat_test_results, :text, limit: 16777215
  end
end
