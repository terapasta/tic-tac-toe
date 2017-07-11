class ChangeDataTypeQuestionFromQuestionAnswers < ActiveRecord::Migration
  def up
    change_column :question_answers, :question, :text
  end

  def down
    change_column :question_answers, :question, :string
  end
end
