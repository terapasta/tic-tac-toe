class RemoveRatingFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :rating, :integer, default: 0, index: true
  end
end
