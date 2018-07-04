class CreateChatworkSimilarQuestionAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :chatwork_similar_question_answers do |t|
      t.integer :chat_id, null: false
      t.string :access_token, null: false
      t.integer :question_answer_id, null: false
      t.string :room_id, null: false
      t.string :from_account_id, null: false

      t.timestamps
      t.index [:access_token], unique: true
    end
  end
end
