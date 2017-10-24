class AddNoClassifiedAnswerIdToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :no_classified_answer_id, :integer, after: :start_answer_id
  end
end
