class CreateWordMappingSynonyms < ActiveRecord::Migration
  def change
    create_table :word_mapping_synonyms do |t|
      t.string :value, null: false
      t.integer :word_mapping_id, null: false

      t.timestamps null: false
    end
  end
end
