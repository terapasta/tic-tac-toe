class AddUserIdToWordMappings < ActiveRecord::Migration[4.2]
  def change
    add_reference :word_mappings, :user, index: true, foreign_key: true
  end
end
