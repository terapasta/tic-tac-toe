class AddPlanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plan, :integer, null: false, default: 2
  end
end
