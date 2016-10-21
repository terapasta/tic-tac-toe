class RemoveColumnContextMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :context
  end
end
