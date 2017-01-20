class CreateImportedTrainingMessages < ActiveRecord::Migration
  def change
    create_table :imported_training_messages do |t|
      t.references :bot, index: true
      t.string :question
      t.references :answer, index: true
      t.text :underlayer

      t.timestamps null: false
    end
  end
end
