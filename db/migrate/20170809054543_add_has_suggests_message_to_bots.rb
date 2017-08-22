class AddHasSuggestsMessageToBots < ActiveRecord::Migration
  def change
    add_column :bots, :has_suggests_message, :text
  end
end
