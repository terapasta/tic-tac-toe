class ChangeDatatypeIsDemoOfBots < ActiveRecord::Migration[5.1]
  def up
    change_column_null :bots, :is_demo, false, false
  end

  def down
    change_column :bots, :is_demo, :boolean
  end
end
