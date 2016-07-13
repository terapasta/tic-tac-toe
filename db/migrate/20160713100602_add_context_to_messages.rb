class AddContextToMessages < ActiveRecord::Migration
  def change
     add_column :messages, :context, :string, after: :speaker
     add_column :training_messages, :context, :string, after: :speaker
  end
end
