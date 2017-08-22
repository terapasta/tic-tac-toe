class CreateWordMappingSynonyms < ActiveRecord::Migration
  def change
    create_table :word_mapping_synonyms do |t|
      t.string :value, null: false
      t.integer :word_mapping_id, null: false

      t.timestamps null: false
    end

    ActiveRecord::Base.transaction do
      WordMapping.find_each do |word|
        WordMappingSynonym.create(value: word.synonym, word_mapping_id: word.id)
      end
    end
  end
end
