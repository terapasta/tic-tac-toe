class CreateContactStates < ActiveRecord::Migration
  def change
    create_table :contact_states do |t|
      t.references :chat, index: true
      t.string :name, null: false
      t.string :email, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
