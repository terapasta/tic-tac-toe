class ChangeColumnTypeOfLearningTrainingMessagesQuestion < ActiveRecord::Migration
  def up
    change_column :learning_training_messages, :question, :text
  end

  def down
    change_column :learning_training_messages, :question, :string
  end
end
