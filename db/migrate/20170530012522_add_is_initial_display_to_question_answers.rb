class AddIsInitialDisplayToQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :question_answers, :is_initial_display, :boolean, default: false
  end
end
