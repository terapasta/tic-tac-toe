class CreateTrainingHelpMessages < ActiveRecord::Migration
  def change
    create_table :training_help_messages do |t|
      t.text :body, null: false
      t.references :help_answer, index: true

      t.timestamps null: false
    end
  end
end
