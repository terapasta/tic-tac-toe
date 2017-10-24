class RemoveDontUseTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :training_texts
    drop_table :tags if ActiveRecord::Base.connection.table_exists? :tags
    drop_table :taggings if ActiveRecord::Base.connection.table_exists? :taggings
    drop_table :contexts
    drop_table :contact_states
    drop_table :contact_answers
    drop_table :auto_tweets
  end
end
