class ChangeDefaultValueOfClassifyThreshold < ActiveRecord::Migration[5.1]
  def change
    change_column_default :learning_parameters, :classify_threshold, 0.6
  end
end
