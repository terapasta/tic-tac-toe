class AddCandidateAnswersThresholdToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :candidate_answers_threshold, :float, default: 0.1, null: false
  end
end
