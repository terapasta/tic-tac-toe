class CreateBotLineCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_line_credentials do |t|
      t.string :channel_id, null: false
      t.string :channel_secret, null: false
      t.string :channel_access_token, null: false
      t.integer :bot_id, null: false

      t.timestamps
    end
  end
end
