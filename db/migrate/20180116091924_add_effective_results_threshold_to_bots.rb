class AddEffectiveResultsThresholdToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :effective_results_threshold, :float
  end
end
