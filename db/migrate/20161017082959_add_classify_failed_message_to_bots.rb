class AddClassifyFailedMessageToBots < ActiveRecord::Migration
  def change
    add_column :bots, :classify_failed_message, :string, after: :token
  end
end
