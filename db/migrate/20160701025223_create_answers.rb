class CreateAnswers < ActiveRecord::Migration[4.2]
  def change
    create_table :answers do |t|
      t.references :context, index: true, null: false
      t.text :body

      t.timestamps null: false
    end
  end
end
