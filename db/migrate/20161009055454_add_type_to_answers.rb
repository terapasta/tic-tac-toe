class AddTypeToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :type, :string, after: :transition_to
    add_column :answers, :defined_answer_id, :integer, after: :id
    add_index :answers, :defined_answer_id, unique: true
  end
end
