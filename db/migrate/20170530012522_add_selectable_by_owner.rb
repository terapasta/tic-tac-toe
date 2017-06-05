class AddSelectableByOwner < ActiveRecord::Migration
  def change
    add_column :question_answers, :selection, :boolean, default: false
  end
end
