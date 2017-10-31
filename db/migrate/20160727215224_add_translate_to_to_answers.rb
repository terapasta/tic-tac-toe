class AddTranslateToToAnswers < ActiveRecord::Migration[4.2]
  def change
    add_column :answers, :transition_to, :string, after: :body
  end
end
