class AddTagIdsToLearningTrainingMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :learning_training_messages, :tag_ids, :text, after: :answer_id
  end
end
