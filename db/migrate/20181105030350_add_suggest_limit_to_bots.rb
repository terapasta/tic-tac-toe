class AddSuggestLimitToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :suggest_limit, :integer, default: 10, null: false
  end
end
