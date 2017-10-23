class AddStartAnswerIdToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :start_answer_id, :integer, index: true, after: :name
  end
end
