class AddAnswerUserModifiedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :answer_user_modified, :boolean, default: false, null:false
  end
end
