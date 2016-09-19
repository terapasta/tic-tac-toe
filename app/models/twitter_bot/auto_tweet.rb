class TwitterBot::AutoTweet < TwitterBot::Base
  def auto
    auto_tweet = ::AutoTweet.all.sample
    client.update(auto_tweet.body)
  end

  def clone
    client.user_timeline('harada4atsushi', exclude_replies: true, include_rts: false).each do |tweet|
      ::AutoTweet.find_or_create_by!(body: tweet.text)
    end
  end
end
