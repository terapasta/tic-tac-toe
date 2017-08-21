class CreateSynonyms < ActiveRecord::Migration
  def change
    create_table :synonyms do |t|
      t.string :value
      t.integer :word_mappings_id

      t.timestamps null: false
    end
  end
end
