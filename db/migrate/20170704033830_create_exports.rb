class CreateExports < ActiveRecord::Migration[4.2]
  def change
    create_table :exports do |t|
      t.string :file, null: false
      t.integer :bot_id, null: false
      t.integer :encoding, null: false

      t.index :bot_id

      t.timestamps null: false
    end
  end
end
