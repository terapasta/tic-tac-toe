class AddUserIdToWordMappings < ActiveRecord::Migration
  def change
    add_reference :word_mappings, :user, index: true, foreign_key: true
  end
end
