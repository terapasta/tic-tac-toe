class AddHasSuggestsMessageToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :has_suggests_message, :text
  end
end
