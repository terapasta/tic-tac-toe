class CreateContactAnswers < ActiveRecord::Migration
  def change
    create_table :contact_answers do |t|
      t.text :body
      t.string :transition_to

      t.timestamps null: false
    end
  end
end
