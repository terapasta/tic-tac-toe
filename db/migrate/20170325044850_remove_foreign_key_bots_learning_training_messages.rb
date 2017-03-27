class RemoveForeignKeyBotsLearningTrainingMessages < ActiveRecord::Migration
  def up
    remove_foreign_key :learning_training_messages, :bots
  end

  def down
    add_foreign_key :learning_training_messages, :bots
  end
end
