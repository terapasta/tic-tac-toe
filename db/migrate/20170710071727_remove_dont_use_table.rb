class RemoveDontUseTable < ActiveRecord::Migration
  def change
    drop_table :training_texts
    drop_table :tags
    drop_table :taggings
    drop_table :contexts
    drop_table :contact_states
    drop_table :contact_answers
    drop_table :auto_tweets
    drop_table :favorite_words
    drop_table :twitter_replies
  end
end
