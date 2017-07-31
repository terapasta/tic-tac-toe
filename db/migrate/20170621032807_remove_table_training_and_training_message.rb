class RemoveTableTrainingAndTrainingMessage < ActiveRecord::Migration
  def change
    remove_index :sentence_synonyms, :training_message_id
    remove_index :training_messages, :question_answer_id
    remove_index :training_messages, :training_id

    remove_column :sentence_synonyms, :training_message_id

    drop_table :trainings
    drop_table :training_messages
  end
end
