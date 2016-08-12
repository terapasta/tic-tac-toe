class AddStartAnswerIdToBots < ActiveRecord::Migration
  def change
    add_column :bots, :start_answer_id, :integer, index: true, after: :name
  end
end
