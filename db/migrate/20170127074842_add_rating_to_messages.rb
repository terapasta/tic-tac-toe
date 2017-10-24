class AddRatingToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :rating, :integer, default: 0
    add_index :messages, :rating
  end
end
