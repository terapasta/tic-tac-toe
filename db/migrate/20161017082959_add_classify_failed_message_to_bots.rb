class AddClassifyFailedMessageToBots < ActiveRecord::Migration[4.2]
  def change
    add_column :bots, :classify_failed_message, :string, after: :token
  end
end
