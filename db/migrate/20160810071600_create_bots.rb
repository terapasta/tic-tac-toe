class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.references :user, index: true
      t.string :name, nil: false

      t.timestamps null: false
    end
  end
end