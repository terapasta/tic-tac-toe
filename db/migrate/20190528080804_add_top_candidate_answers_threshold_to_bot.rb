class AddTopCandidateAnswersThresholdToBot < ActiveRecord::Migration[5.2]
  def change
    add_column :bots, :top_candidate_answers_threshold, :float, default: 0, null: false
  end
end
