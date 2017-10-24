class CreateWordMappings < ActiveRecord::Migration[4.2]
  def change
    create_table :word_mappings do |t|
      t.string :word, null: false, limit: 20
      t.string :synonym, null: false, limit: 20

      t.timestamps null: false
    end
  end
end
