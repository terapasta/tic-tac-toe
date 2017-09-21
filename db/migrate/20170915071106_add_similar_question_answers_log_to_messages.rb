class AddSimilarQuestionAnswersLogToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :similar_question_answers_log, :text
  end
end
