namespace :twitter do
  task reply: :environment do
    TwitterBot::Bot.new.reply
  end

  task auto_reply: :environment do
    TwitterBot::Bot.new.auto_reply
  end

  task favorite: :environment do
    TwitterBot::Bot.new.favorite_all
  end

  task auto_tweet: :environment do
    TwitterBot::Bot.new.auto_tweet
  end

  task clone_tweets: :environment do
    TwitterBot::Bot.new.clone_tweets
  end
end
