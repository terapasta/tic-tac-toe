class RemoveColumnHeadlineAnswers < ActiveRecord::Migration
  def change
    remove_column :answers, :headline
  end
end
