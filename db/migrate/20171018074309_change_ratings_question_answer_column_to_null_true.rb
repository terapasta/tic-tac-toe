class ChangeRatingsQuestionAnswerColumnToNullTrue < ActiveRecord::Migration
  def up
    change_column :ratings, :question_answer_id, :integer, null: true
  end

  def down
    change_column :ratings, :question_answer_id, :integer, null: false
  end
end
