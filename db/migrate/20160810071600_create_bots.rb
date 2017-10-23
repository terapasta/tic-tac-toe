class CreateBots < ActiveRecord::Migration[4.2]
  def change
    create_table :bots do |t|
      t.references :user, index: true
      t.string :name, nil: false

      t.timestamps null: false
    end
  end
end
