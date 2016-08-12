class CreateHelpAnswers < ActiveRecord::Migration
  def change
    create_table :help_answers do |t|
      t.references :bot, index: true
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
