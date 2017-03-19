class AddAnswerFailedByUserToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :answer_failed_by_user, :boolean, default: false, null:false
  end
end
