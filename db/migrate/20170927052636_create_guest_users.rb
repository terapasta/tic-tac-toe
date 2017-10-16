class CreateGuestUsers < ActiveRecord::Migration
  def change
    create_table :guest_users do |t|
      t.string :name, null: false
      t.string :email
      t.string :guest_key, null: false

      t.timestamps null: false

      t.index :guest_key
    end
  end
end
