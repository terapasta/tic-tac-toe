class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :feature, null: false
      t.boolean :enabled, null: false

      t.timestamps null: false
    end
  end
end
