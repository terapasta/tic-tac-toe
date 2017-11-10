class AddIsShowSimilarQuestionAnswersToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :is_show_similar_question_answers, :boolean, default: true
  end
end
