class CreateSubQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :sub_questions do |t|
      t.integer :question_answer_id, null: false
      t.text :question

      t.timestamps
    end
  end
end
