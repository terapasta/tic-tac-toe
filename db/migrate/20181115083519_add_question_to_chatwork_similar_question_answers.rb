class AddQuestionToChatworkSimilarQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :chatwork_similar_question_answers, :question, :text
  end
end
