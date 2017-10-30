class RemoveColumnUserIdWordMapping < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :word_mappings, :users
    remove_index :word_mappings, :user_id
    remove_column :word_mappings, :user_id
  end
end
