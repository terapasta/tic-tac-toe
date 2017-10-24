class DeleteUnderlayerFromQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    remove_column :question_answers, :underlayer, :text
  end
end
