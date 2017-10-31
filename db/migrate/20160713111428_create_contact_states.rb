class CreateContactStates < ActiveRecord::Migration[4.2]
  def change
    create_table :contact_states do |t|
      t.references :chat, index: true
      t.string :name
      t.string :email
      t.text :body

      t.timestamps null: false
    end
  end
end
