class AddTranslateToToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :transition_to, :string, after: :body
  end
end
