class RemoveForeignKeyBotsLearningTrainingMessages < ActiveRecord::Migration[4.2]
  def up
    remove_foreign_key :learning_training_messages, :bots
  end

  def down
    add_foreign_key :learning_training_messages, :bots
  end
end
