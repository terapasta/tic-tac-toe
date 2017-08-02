class AddQuestionAnswerIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :question_answer_id, :integer
    add_index :messages, [:question_answer_id]
  end
end
