class CreateTutorials < ActiveRecord::Migration[5.1]
  def change
    create_table :tutorials do |t|
      t.integer :bot_id, null: false
      t.boolean :edit_bot_profile, null: false, default: false
      t.boolean :fifty_question_answers, null: false, default: false
      t.boolean :ask_question, null: false, default: false
      t.boolean :embed_chat, null: false, default: false

      t.timestamps
    end
  end
end
