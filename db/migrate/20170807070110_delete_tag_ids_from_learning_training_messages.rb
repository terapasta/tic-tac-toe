class DeleteTagIdsFromLearningTrainingMessages < ActiveRecord::Migration[4.2]
  def up
    remove_column :learning_training_messages, :tag_ids
  end

  def down
    add_column :learning_training_messages, :tag_ids, :text
  end
end
