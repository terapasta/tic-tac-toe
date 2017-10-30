class CreateOrganizations < ActiveRecord::Migration[4.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :image
      t.text :description
      t.integer :plan, null: false, default: 2

      t.timestamps null: false
    end
  end
end
