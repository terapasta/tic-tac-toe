class RemoveColumnSynonymForWordMapping < ActiveRecord::Migration
  def up
    remove_column :word_mappings, :synonym
  end
  
  def down
    add_column :word_mappings, :synonym, :string
  end
end
