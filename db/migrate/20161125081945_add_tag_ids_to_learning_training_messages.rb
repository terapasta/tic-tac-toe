class AddTagIdsToLearningTrainingMessages < ActiveRecord::Migration
  def change
    add_column :learning_training_messages, :tag_ids, :text, after: :answer_id
  end
end
