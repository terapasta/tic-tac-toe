class CreateAllowedHosts < ActiveRecord::Migration[4.2]
  def change
    create_table :allowed_hosts do |t|
      t.integer :scheme, default: 0
      t.string :domain, null: false
      t.integer :bot_id, null: false

      t.timestamps null: false
      t.index [:scheme, :domain, :bot_id], unique: true
    end
  end
end
