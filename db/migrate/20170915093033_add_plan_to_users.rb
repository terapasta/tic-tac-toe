class AddPlanToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :plan, :integer, null: false, default: 2
  end
end
