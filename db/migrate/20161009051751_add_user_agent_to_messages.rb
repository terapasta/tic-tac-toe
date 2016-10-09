class AddUserAgentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_agent, :string, limit: 1024, after: :body
  end
end
