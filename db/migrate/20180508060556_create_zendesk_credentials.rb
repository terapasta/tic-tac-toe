class CreateZendeskCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :zendesk_credentials do |t|
      t.integer :bot_id, null: false
      t.string :url, null: false
      t.string :username, null: false
      t.string :access_token, null: false

      t.timestamps
      t.index [:bot_id]
    end
  end
end
