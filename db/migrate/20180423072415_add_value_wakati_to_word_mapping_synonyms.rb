class AddValueWakatiToWordMappingSynonyms < ActiveRecord::Migration[5.1]
  def change
    add_column :word_mapping_synonyms, :value_wakati, :string
  end
end
