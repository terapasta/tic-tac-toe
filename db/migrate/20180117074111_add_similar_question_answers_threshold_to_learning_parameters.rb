class AddSimilarQuestionAnswersThresholdToLearningParameters < ActiveRecord::Migration[5.1]
  def change
    add_column :learning_parameters, :similar_question_answers_threshold, :float
  end
end
