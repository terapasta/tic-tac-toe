class AddFeedbackParamsToLearningParameters < ActiveRecord::Migration[5.1]
  def change
    add_column :learning_parameters, :feedback_algorithm, :integer, default: 0, null: false, after: :algorithm
    add_column :learning_parameters, :parameters_for_feedback, :json, after: :feedback_algorithm
    remove_column :learning_parameters, :params_for_algorithm, :text, after: :algorithm
    add_column :learning_parameters, :parameters, :json, after: :algorithm
  end
end
