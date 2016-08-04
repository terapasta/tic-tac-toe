class CreateFavoriteWords < ActiveRecord::Migration
  def change
    create_table :favorite_words do |t|
      t.string :word

      t.timestamps null: false
    end
  end
end
