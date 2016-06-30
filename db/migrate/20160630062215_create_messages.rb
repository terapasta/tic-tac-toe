class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :chat, index: true, foreign_key: true
      t.string :speaker
      t.string :body

      t.timestamps null: false
    end
  end
end
