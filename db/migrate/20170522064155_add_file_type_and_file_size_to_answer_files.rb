class AddFileTypeAndFileSizeToAnswerFiles < ActiveRecord::Migration
  def change
    add_column :answer_files, :file_type, :string, null: false
    add_column :answer_files, :file_size, :integer, default: 0
  end
end