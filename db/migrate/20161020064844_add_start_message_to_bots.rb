class AddStartMessageToBots < ActiveRecord::Migration
  def change
    add_column :bots, :start_message, :string, after: :classify_failed_message
    remove_column :bots, :start_answer_id
  end
end
