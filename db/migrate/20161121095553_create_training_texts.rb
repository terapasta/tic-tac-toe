class CreateTrainingTexts < ActiveRecord::Migration[4.2]
  def change
    create_table :training_texts do |t|
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
