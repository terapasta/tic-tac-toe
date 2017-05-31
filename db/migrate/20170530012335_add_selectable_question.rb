class AddSelectableQuestion < ActiveRecord::Migration
  def change
    add_column :bots, :selectable_question, :boolean, default: false
  end
end
