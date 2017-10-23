class AddSimilarQuestionAnswersLogToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :similar_question_answers_log, :text
  end
end
