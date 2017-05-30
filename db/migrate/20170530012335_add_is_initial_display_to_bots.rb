class AddIsInitialDisplayToBots < ActiveRecord::Migration
  def change
    add_column :bots, :is_initial_display, :boolean, default: false
  end
end
