class AddTrainedAtToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :trained_at, :datetime
    add_index :messages, :trained_at
  end
end
