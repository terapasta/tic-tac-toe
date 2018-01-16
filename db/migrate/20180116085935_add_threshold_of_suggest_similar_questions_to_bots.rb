class AddThresholdOfSuggestSimilarQuestionsToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :threshold_of_suggest_similar_questions, :float
  end
end
