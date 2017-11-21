class AddReplyLogToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :reply_log, :json
  end
end
