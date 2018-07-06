class AddColumnToQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :question_answers, :question_answers_count, :integer, default: 0
  end
end
