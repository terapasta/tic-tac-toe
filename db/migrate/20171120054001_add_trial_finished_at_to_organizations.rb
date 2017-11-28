class AddTrialFinishedAtToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :trial_finished_at, :datetime
  end
end
