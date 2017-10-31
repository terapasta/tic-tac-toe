class CreateTrainingMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :training_messages do |t|
      t.references :training, index: true, null: false
      t.integer :answer_id
      t.string :speaker, null: false
      t.string :body

      t.timestamps null: false
    end
  end
end
