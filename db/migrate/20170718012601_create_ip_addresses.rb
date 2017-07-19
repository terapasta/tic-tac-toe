class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
      t.string :permission, null: false
      t.integer :bot_id, null: false

      t.timestamps null: false
    end
  end
end
