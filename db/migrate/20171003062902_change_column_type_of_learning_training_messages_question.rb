class ChangeColumnTypeOfLearningTrainingMessagesQuestion < ActiveRecord::Migration[4.2]
  def up
    change_column :learning_training_messages, :question, :text
  end

  def down
    change_column :learning_training_messages, :question, :string
  end
end
