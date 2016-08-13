namespace :twitter do
  task reply: :environment do
    TwitterBot.new.reply
  end

  task auto_reply: :environment do
    TwitterBot.new.auto_reply
  end

  task favorite: :environment do
    TwitterBot.new.favorite_all
  end

  task auto_tweet: :environment do
    TwitterBot.new.auto_tweet
  end

  task clone_tweets: :environment do
    TwitterBot.new.clone_tweets
  end
end
