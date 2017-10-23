class AddClassifyThresholdToLearningParameters < ActiveRecord::Migration[4.2]
  def change
    add_column :learning_parameters, :classify_threshold, :float, after: :include_failed_data, null: false, default: 0.5
  end
end
