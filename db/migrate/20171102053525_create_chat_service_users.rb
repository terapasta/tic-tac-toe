class CreateChatServiceUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_service_users do |t|
      t.integer :bot_id, null: false
      t.integer :service_type, default: 0, null: false
      t.string :uid, null: false
      t.string :name
      t.string :guest_key, null: false, default: ''

      t.timestamps
      t.index [:bot_id, :service_type, :uid], unique: true
    end
  end
end
