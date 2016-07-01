class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
