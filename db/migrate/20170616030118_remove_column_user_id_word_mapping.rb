class RemoveColumnUserIdWordMapping < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      word_mappings = WordMapping.where('user_id IS NOT NULL')
      word_mappings.each do |word_mapping|
        word_mapping.user_id = nil
        word_mapping.save!
      end
    end
    remove_foreign_key :word_mappings, :users
    remove_index :word_mappings, :user_id
    remove_column :word_mappings, :user_id
  end
end
