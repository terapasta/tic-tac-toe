class AddDemoToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :demo, :boolean
  end
end
