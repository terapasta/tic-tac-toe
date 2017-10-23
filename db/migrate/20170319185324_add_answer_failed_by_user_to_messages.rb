class AddAnswerFailedByUserToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :answer_failed_by_user, :boolean, default: false, null:false
  end
end
