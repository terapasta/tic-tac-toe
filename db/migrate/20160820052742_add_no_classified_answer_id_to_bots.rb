class AddNoClassifiedAnswerIdToBots < ActiveRecord::Migration
  def change
    add_column :bots, :no_classified_answer_id, :integer, after: :start_answer_id
  end
end
