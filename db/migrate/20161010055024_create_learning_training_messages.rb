class CreateLearningTrainingMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :learning_training_messages do |t|
      t.references :bot, index: true, foreign_key: true
      t.string :question
      t.string :answer_body
      t.references :answer, index: true

      t.timestamps null: false
    end
  end
end
