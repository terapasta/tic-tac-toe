class CreateAnswerFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :answer_files do |t|
      t.integer :answer_id, null: false
      t.string :file, null: false

      t.timestamps null: false
    end
  end
end
