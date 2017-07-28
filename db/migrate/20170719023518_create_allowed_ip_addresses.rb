class CreateAllowedIpAddresses < ActiveRecord::Migration
  def change
    create_table :allowed_ip_addresses do |t|
      t.string :value, null: false
      t.integer :bot_id, null: false

      t.timestamps null: false
    end
  end
end
