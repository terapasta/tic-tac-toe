class AddWordWakatiToWordMappings < ActiveRecord::Migration[5.1]
  def change
    add_column :word_mappings, :word_wakati, :string
  end
end
