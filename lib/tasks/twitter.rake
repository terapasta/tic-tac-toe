namespace :twitter do
  task reply: :environment do
    TwitterBot::Reply.new.all
  end

  task auto_reply: :environment do
    TwitterBot::Reply.new.auto
  end

  task favorite: :environment do
    TwitterBot::Favorite.new.all
  end

  task auto_tweet: :environment do
    TwitterBot::AutoTweet.new.auto
  end

  task clone_tweets: :environment do
    TwitterBot::AutoTweet.new.clone
  end
end
