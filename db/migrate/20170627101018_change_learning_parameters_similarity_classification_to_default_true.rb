class ChangeLearningParametersSimilarityClassificationToDefaultTrue < ActiveRecord::Migration[4.2]
  def change
    change_column :learning_parameters, :use_similarity_classification, :boolean, after: :classify_threshold, null: false, default: true
  end
end
