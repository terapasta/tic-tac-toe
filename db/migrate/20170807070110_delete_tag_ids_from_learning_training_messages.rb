class DeleteTagIdsFromLearningTrainingMessages < ActiveRecord::Migration
  def up
    remove_column :learning_training_messages, :tag_ids
  end

  def down
    add_column :learning_training_messages, :tag_ids, :text
  end
end
