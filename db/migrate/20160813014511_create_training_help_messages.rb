class CreateTrainingHelpMessages < ActiveRecord::Migration[4.2]
  def change
    create_table :training_help_messages do |t|
      t.references :bot, index: true
      t.text :body, null: false
      t.references :help_answer, index: true

      t.timestamps null: false
    end
  end
end
