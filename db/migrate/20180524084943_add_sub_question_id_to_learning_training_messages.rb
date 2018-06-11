class AddSubQuestionIdToLearningTrainingMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :learning_training_messages, :sub_question_id, :integer
  end
end
