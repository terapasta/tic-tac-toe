class AddAnswerFailedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :answer_failed, :boolean, after: :user_agent, default: false, null: false
  end
end
