class RemoveNullRestrictionForWordMapping < ActiveRecord::Migration[4.2]
  def up
    change_column_null :word_mappings, :synonym, true
  end

  def down
    change_column_null :word_mappings, :synonym, false
  end
end
