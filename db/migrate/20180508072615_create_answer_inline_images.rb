class CreateAnswerInlineImages < ActiveRecord::Migration[5.0]
  def change
    create_table :answer_inline_images do |t|
      t.string :file, null: false
      t.references :bot, foreign_key: true

      t.timestamps
    end
  end
end
