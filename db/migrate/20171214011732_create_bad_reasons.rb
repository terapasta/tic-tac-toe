class CreateBadReasons < ActiveRecord::Migration[5.1]
  def change
    create_table :bad_reasons do |t|
      t.integer :message_id, null: false
      t.text :body
      t.integer :guest_user_id

      t.timestamps
    end
  end
end
