class AddDemoToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :demo, :boolean, default: false, null: false
  end
end
