class AddHeadlineToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :headline, :string, after: :transition_to, limit: 100
  end
end
