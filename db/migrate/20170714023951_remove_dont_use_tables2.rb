class RemoveDontUseTables2 < ActiveRecord::Migration[4.2]
  def change
    drop_table :favorite_words
    drop_table :twitter_replies
  end
end
