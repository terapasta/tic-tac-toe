class RemoveDontUseTables2 < ActiveRecord::Migration
  def change
    drop_table :favorite_words
    drop_table :twitter_replies
  end
end
