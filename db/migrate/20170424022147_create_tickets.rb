class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :recipient,   null: false
      t.string :subject,     null: false
      t.string :description, null: false

      t.timestamps null: false
    end
  end
end
