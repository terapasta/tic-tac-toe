class DeleteTrainedAtFromMessages < ActiveRecord::Migration[4.2]
  def up
    remove_column :messages, :trained_at
  end

  def down
    remove_column :messages, :trained_at, :datetime
  end
end
