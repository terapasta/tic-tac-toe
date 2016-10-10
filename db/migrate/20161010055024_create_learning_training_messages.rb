class CreateLearningTrainingMessages < ActiveRecord::Migration
  def change
    create_table :learning_training_messages do |t|
      t.references :bot, index: true, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps null: false
    end
  end
end
