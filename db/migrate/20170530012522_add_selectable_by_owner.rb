class AddSelectableByOwner < ActiveRecord::Migration[4.2]
  def change
    add_column :question_answers, :selection, :boolean, default: false
  end
end
