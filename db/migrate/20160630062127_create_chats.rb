class CreateChats < ActiveRecord::Migration[4.2]
  def change
    create_table :chats do |t|
      t.string :guest_key, null: false

      t.timestamps null: false
    end
  end
end
