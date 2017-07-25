class RemoveDontUseTable < ActiveRecord::Migration
  def change
    drop_table :training_texts
    drop_table :contexts
    drop_table :contact_states
    drop_table :contact_answers
    drop_table :auto_tweets
  end
end
