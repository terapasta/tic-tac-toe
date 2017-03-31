class RenameAnswerFailedByUserToAnswerMarked < ActiveRecord::Migration
  def change
    rename_column :messages, :answer_failed_by_user, :answer_marked
  end
end
