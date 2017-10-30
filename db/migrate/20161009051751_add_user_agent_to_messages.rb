class AddUserAgentToMessages < ActiveRecord::Migration[4.2]
  def change
    add_column :messages, :user_agent, :string, limit: 1024, after: :body
  end
end
