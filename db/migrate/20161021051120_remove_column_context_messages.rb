class RemoveColumnContextMessages < ActiveRecord::Migration[4.2]
  def change
    remove_column :messages, :context
  end
end
