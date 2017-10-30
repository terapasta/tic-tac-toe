class AddStartMessageToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :start_message, :string, after: :classify_failed_message
    remove_column :bots, :start_answer_id
    remove_column :bots, :no_classified_answer_id
  end
end
