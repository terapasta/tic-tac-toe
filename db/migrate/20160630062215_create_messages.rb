class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :chat, index: true
      t.integer :answer_id
      t.string :speaker, null: false
      t.string :body

      t.timestamps null: false
    end
  end
end
