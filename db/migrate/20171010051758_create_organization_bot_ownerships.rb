class CreateOrganizationBotOwnerships < ActiveRecord::Migration[4.2]
  def change
    create_table :organization_bot_ownerships do |t|
      t.integer :organization_id, null: false
      t.integer :bot_id, null: false

      t.timestamps null: false
      t.index [:organization_id, :bot_id], unique: true, name: 'main_organization_bot_ownership_index'
    end
  end
end
