class AddQuestionAnswerIdToLearninigTrainingMessages < ActiveRecord::Migration
  def change
    add_column :learning_training_messages, :question_answer_id, :integer
    add_index :learning_training_messages, :question_answer_id
  end
end
