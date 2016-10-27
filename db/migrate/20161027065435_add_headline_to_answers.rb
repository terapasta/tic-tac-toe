class AddHeadlineToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :headline, :string, after: :transition_to, limit: 100
  end
end
