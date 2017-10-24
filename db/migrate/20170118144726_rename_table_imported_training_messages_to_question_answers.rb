class RenameTableImportedTrainingMessagesToQuestionAnswers < ActiveRecord::Migration[4.2]
  def change
    rename_table :imported_training_messages, :question_answers
    rename_column :training_messages, :imported_training_message_id, :question_answer_id
  end
end
