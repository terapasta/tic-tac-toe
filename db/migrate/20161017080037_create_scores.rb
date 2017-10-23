class CreateScores < ActiveRecord::Migration[4.2]
  def change
    create_table :scores do |t|
      t.references :bot, index: true, null: false
      t.float :accuracy
      t.float :precision
      t.float :recall
      t.float :f1

      t.timestamps null: false
    end
  end
end
