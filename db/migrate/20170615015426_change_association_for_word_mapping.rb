class ChangeAssociationForWordMapping < ActiveRecord::Migration
  def up
    add_column :word_mappings, :bot_id, :integer
    add_index :word_mappings, :bot_id

    ActiveRecord::Base.transaction do
      word_mappings = WordMapping.where('user_id IS NOT NULL')
      word_mappings.each do |word_mapping|
        word_mapping.bot_id = word_mapping.user.bots.first&.id
        word_mapping.user_id= nil
        word_mapping.save!
      end
    end
  end

  def down
    remove_column :word_mappings, :bot_id
    remove_index :word_mappings, :bot_id
  end
end
