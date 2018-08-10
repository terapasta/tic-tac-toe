class ChangeColumnToLearningParameter < ActiveRecord::Migration[5.1]
  def change
    change_column :learning_parameters, :feedback_algorithm, :integer, default: 1
  end
end
