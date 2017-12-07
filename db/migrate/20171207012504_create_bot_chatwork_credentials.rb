class CreateBotChatworkCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_chatwork_credentials do |t|
      t.string :api_token, null: false
      t.integer :bot_id, null: false

      t.timestamps
    end
  end
end
