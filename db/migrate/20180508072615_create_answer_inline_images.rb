class CreateAnswerInlineImages < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_inline_images do |t|
      t.string :file, null: false
      t.integer :bot_id, foreign_key: true

      t.timestamps
    end
  end
end
