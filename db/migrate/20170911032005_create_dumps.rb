class CreateDumps < ActiveRecord::Migration
  def change
    create_table :dumps do |t|
      t.integer :bot_id, null: false
      t.string :name, null: false
      t.binary :content, limit: 3.gigabytes
    end
  end
end