class CreateLearningParameters < ActiveRecord::Migration
  def change
    create_table :learning_parameters do |t|
      t.references :bot, index: true, foreign_key: true
      t.boolean :include_failed_data

      t.timestamps null: false
    end
  end
end
