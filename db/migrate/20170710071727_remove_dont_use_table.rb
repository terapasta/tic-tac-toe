class RemoveDontUseTable < ActiveRecord::Migration
  def change
    drop_table :training_texts
    ActiveRecord::Migration.drop_table :tags if ActiveRecord::Base.connection.table_exists? :tags
    ActiveRecord::Migration.drop_table :taggings if ActiveRecord::Base.connection.table_exists? :taggings
    drop_table :contexts
    drop_table :contact_states
    drop_table :contact_answers
    drop_table :auto_tweets
  end
end
