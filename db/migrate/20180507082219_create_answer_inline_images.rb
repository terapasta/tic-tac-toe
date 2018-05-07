class CreateAnswerInlineImages < ActiveRecord::Migration[5.1]
  def change
    create_table :answer_inline_images do |t|
      t.string :file

      t.timestamps
    end
  end
end
