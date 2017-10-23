class AddImportedTrainingMessageIdToTrainingMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :training_messages, :imported_training_message_id, :integer, after: :answer_id
    add_index :training_messages, :imported_training_message_id
  end
end
