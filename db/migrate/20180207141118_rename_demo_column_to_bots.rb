class RenameDemoColumnToBots < ActiveRecord::Migration[5.1]
  def change
    rename_column :bots, :demo, :is_demo
  end
end
