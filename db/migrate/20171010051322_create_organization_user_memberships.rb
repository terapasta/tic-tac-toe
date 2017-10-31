class CreateOrganizationUserMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :organization_user_memberships do |t|
      t.integer :user_id, null: false
      t.integer :organization_id, null: false

      t.timestamps null: false
      t.index [:user_id, :organization_id], unique: true, name: :main_organization_user_membership_index
    end
  end
end
