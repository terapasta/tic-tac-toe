class RemoveRatingFromMessages < ActiveRecord::Migration[4.2]
  def change
    remove_column :messages, :rating, :integer, default: 0, index: true
  end
end
