class AddIndexOnGuestMessageIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_index :messages, :guest_message_id
  end
end
