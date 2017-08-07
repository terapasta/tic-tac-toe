class DeleteSelectionFromQuestionAnswers < ActiveRecord::Migration
  def up
    remove_column :question_answers, :selection
  end

  def down
    add_column :question_answers, :selection, :boolean, default: false
  end
end
