class ChangeDataTypeQuestionFromQuestionAnswers < ActiveRecord::Migration[4.2]
  def up
    change_column :question_answers, :question, :text
  end

  def down
    change_column :question_answers, :question, :string
  end
end
