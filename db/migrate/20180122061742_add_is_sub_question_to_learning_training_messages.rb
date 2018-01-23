class AddIsSubQuestionToLearningTrainingMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :learning_training_messages, :is_sub_question, :boolean, default: false
  end
end
