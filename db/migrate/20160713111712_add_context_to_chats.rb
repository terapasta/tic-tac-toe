class AddContextToChats < ActiveRecord::Migration
  def change
    add_column :chats, :context, :string, after: :id
    add_column :trainings, :context, :string, after: :id
    add_column :messages, :context, :string, after: :speaker
  end
end
