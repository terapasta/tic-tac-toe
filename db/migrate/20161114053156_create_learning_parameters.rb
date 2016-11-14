class CreateLearningParameters < ActiveRecord::Migration
  def change
    create_table :learning_parameters do |t|
      t.references :bot, index: true
      t.boolean :include_failed_data, default: true, null: false

      t.timestamps null: false
    end
  end
end
