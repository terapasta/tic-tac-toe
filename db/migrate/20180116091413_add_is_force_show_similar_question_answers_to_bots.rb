class AddIsForceShowSimilarQuestionAnswersToBots < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :is_force_show_similar_question_answers, :boolean, default: false, null: false
  end
end
