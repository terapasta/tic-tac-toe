class AddDemoFinishedAtToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :demo_finished_at, :datetime
  end
end
