class CreateDataSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :data_summaries do |t|
      t.integer :bot_id, null: false
      t.json :data
      t.string :type_name, null: false

      t.timestamps
      t.index [:bot_id, :type_name]
    end
  end
end
