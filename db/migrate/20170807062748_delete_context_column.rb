class DeleteContextColumn < ActiveRecord::Migration
  def up
    remove_column :chats, :context
  end

  def down
    add_column :chats, :context, :string
  end
end
