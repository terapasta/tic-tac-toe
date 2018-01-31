class AddChatTestJobErrorToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :chat_test_job_error, :text
  end
end
