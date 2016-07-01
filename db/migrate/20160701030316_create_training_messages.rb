class CreateTrainingMessages < ActiveRecord::Migration
  def change
    create_table :training_messages do |t|
      t.references :training, index: true, null: false
      t.string :speaker, null: false
      t.string :body

      t.timestamps null: false
    end
  end
end
