class CreateAutoTweets < ActiveRecord::Migration
  def change
    create_table :auto_tweets do |t|
      t.string :body, null: false

      t.timestamps null: false
    end
  end
end
