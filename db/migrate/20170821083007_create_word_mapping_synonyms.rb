class CreateWordMappingSynonyms < ActiveRecord::Migration
  def change
    create_table :word_mapping_synonyms do |t|
      t.string :value
      t.integer :word_mapping_id

      t.timestamps null: false
    end

    ActiveRecord::Base.transaction do
      word_mappings = WordMapping.all
      word_mappings.each do |word|
        WordMappingSynonym.create(value: word.synonym, word_mapping_id: word.id)
      end
    end
  end
end
