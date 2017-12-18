class CreateBotMicrosoftCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_microsoft_credentials do |t|
      t.string :app_id, null: false
      t.string :app_password, null: false
      t.integer :bot_id, null: false
      t.timestamps
    end
  end
end
