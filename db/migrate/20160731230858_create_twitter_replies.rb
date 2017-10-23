class CreateTwitterReplies < ActiveRecord::Migration[4.2]
  def change
    create_table :twitter_replies do |t|
      t.integer :tweet_id, null: false, limit: 8
      t.string :screen_name

      t.timestamps null: false
    end
  end
end
