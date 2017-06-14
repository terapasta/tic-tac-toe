class ChangeAssociationForWordMapping < ActiveRecord::Migration
  def up
    add_column :word_mappings, :bot_id, :integer
    add_index :word_mappings, :bot_id

    ActiveRecord::Base.transaction do
      word_mappings = WordMapping.all
      word_mappings.each do |word_mapping|
        word_mapping.bot_id = word_mapping.user&.bots&.first&.id
        # バリテーションで落ちる (単語と同意語の組み合わせは既に存在しています)
        word_mapping.save!
      end
    end
  end

  def down
    ActiveRecord::Base.transaction do
      remove_column :word_mappings, :bot_id
      remove_index :word_mappings, :bot_id
    end
  end
end
