class CreateTopicTags < ActiveRecord::Migration[4.2]
  def change
    create_table :topic_tags do |t|
      t.string :name, null: false
      t.integer :bot_id, null: false

      t.timestamps null: false
      t.index [:name, :bot_id], unique: true
    end
  end
end
