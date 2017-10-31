class AddQuestionAnswerIdToLearninigTrainingMessages < ActiveRecord::MigrationA[4.2
  def change
    add_column :learning_training_messages, :question_answer_id, :integer
    add_index :learning_training_messages, :question_answer_id
  end
end
