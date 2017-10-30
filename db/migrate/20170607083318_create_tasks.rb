class CreateTasks < ActiveRecord::Migration[4.2]
  def change
    create_table :tasks do |t|
      t.text :guest_message, limit: 65535
      t.text :bot_message, limit: 65535
      t.boolean :is_done, default: false
      t.integer :bot_id, null: false

      t.timestamps null: false
    end
  end
end
