class AddSelectableByOwner < ActiveRecord::Migration
  def change
    add_column :question_answers, :selectable_by_owner, :boolean, default: false
  end
end
