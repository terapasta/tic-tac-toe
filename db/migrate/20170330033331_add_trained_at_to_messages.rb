class AddTrainedAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :trained_at, :datetime
    add_index :messages, :trained_at
  end
end
