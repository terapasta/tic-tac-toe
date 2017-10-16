class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :level, null: false
      t.integer :message_id, null: false
      t.integer :question_answer_id, null: false
      t.integer :bot_id, null: false
      t.text :question, null: false
      t.text :answer, null: false

      t.timestamps null: false
    end
  end
end
