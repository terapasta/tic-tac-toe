class RemoveColumnHeadlineAnswers < ActiveRecord::Migration[4.2]
  def change
    remove_column :answers, :headline
  end
end
