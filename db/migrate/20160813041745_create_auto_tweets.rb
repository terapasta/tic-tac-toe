class CreateAutoTweets < ActiveRecord::Migration[4.2]
  def change
    create_table :auto_tweets do |t|
      t.string :body, null: false

      t.timestamps null: false
    end
  end
end
