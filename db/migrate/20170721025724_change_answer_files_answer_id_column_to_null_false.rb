class ChangeAnswerFilesAnswerIdColumnToNullFalse < ActiveRecord::Migration[4.2]
  def up
    change_column :answer_files, :answer_id, :integer, null: true
  end

  def down
    change_column :answer_files, :answer_id, :integer, null: false
  end
end
