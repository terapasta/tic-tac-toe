class RemoveUseSimilarityClassificationFromLearningParameters < ActiveRecord::Migration
  def change
    remove_column :learning_parameters, :use_similarity_classification, :boolean, after: :classify_threshold, null: false, default: true
  end
end
