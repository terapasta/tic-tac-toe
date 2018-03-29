class AddCreatedAtToDumps < ActiveRecord::Migration[5.1]
  def change
    add_column :dumps, :created_at, :datetime
  end
end
