class AddRatingToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :rating, :integer, default: 0
    add_index :messages, :rating
  end
end
