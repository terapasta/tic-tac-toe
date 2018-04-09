class ChangeDefaultValueOfLearningParametersAlgorithm < ActiveRecord::Migration[5.1]
  def change
    change_column_default :learning_parameters, :algorithm, 8 # fuzzy_similarity_classification
  end
end
