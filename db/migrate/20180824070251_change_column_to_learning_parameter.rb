class ChangeColumnToLearningParameter < ActiveRecord::Migration[5.1]
  def up
    change_column :learning_parameters, :feedback_algorithm, :integer, default: 1
  end

  def down
    change_column :learning_parameters, :feedback_algorithm, :integer, default: 0
  end
end
