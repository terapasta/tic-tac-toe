class AddAnyTablesUserIdAndBotId < ActiveRecord::Migration
  def change
    add_column :answers, :bot_id, :integer, before: :context, null: false
    add_column :chats, :bot_id, :integer, before: :context, null: false
    add_column :contact_answers, :bot_id, :integer, before: :body, null: false
    add_column :favorite_words, :bot_id, :integer, before: :word, null: false
    add_column :services, :bot_id, :integer, before: :feature, null: false
    add_column :trainings, :bot_id, :integer, before: :context, null: false
    add_column :twitter_replies, :bot_id, :integer, before: :tweet_id, null: false
  end
end
