class AddUseSimilarityClassificationToLearningParameters < ActiveRecord::Migration[4.2]
  def change
    add_column :learning_parameters, :use_similarity_classification, :boolean, after: :classify_threshold, null: false, default: false
  end
end
