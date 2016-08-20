# TODO クラスが大きくなってきたので分割したい
class TwitterBot::Bot
  include Rails.application.routes.url_helpers

  # TODO DRYにしたい
  BOT_SCREEN_NAME = 'donusagi_bot'

  def initialize
    @client = Twitter::REST::Client.new(
      consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
      access_token:        ENV['TWITTER_ACCESS_TOKEN'],
      access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET'],
    )
  end

  def reply
    bot = ::Bot.find(1)  # HACK Twitter機能ONのbotのみ動作させる(一旦固定値)
    @client.mentions_timeline.reverse_each do |mention|
      tweet = TwitterBot::Tweet.new(@client, mention, bot)
      next if tweet.replied?
      next if tweet.self_tweet?

      tweet.reply
    end
  end

  # def reply
  #   bot_id = 1  # HACK Twitter機能ONのbotのみ動作させる(一旦固定値)
  #   @client.mentions_timeline.reverse_each do |mention|
  #     tweet_id = TwitterReply.maximum(:tweet_id) || 0
  #     next if mention.id <= tweet_id
  #     next if mention.user.screen_name == BOT_SCREEN_NAME
  #
  #     puts mention.text
  #     screen_name = mention.user.screen_name
  #     TwitterReply.create!(bot_id: bot_id, tweet_id: mention.id, screen_name: screen_name)
  #
  #     endpoint = api_v1_messages_url
  #
  #     response = HTTP.headers('Content-Type' => "application/json")
  #      .post(endpoint, json: { message: mention.text, bot_id: bot_id, guest_key: mention.user.id })
  #
  #     messages = response.parse.with_indifferent_access[:messages]
  #     messages.each do |message|
  #       body = "#{message[:body]} #{Time.now}"
  #       puts "body: #{body}"
  #       @client.update("@#{screen_name} #{body}", in_reply_to_status_id: mention.id)
  #     end
  #
  #   end
  # end

  def auto_reply
    str = "どんうさぎ -RT"
    endpoint = api_v1_messages_url
    follower_screen_names = @client.followers.map(&:screen_name)

    tweets = @client.search(str)
      .select{|t| t.user.screen_name != BOT_SCREEN_NAME}
      .select{|t| follower_screen_names.include?(t.user.screen_name)}
      .select{|t| t.created_at.today?}  # リプライを重複させないためひとまず当日のツイートのみに反応させる。理想はリプライしたTweetを記憶しておくこと
      .select{|t| t.text.include?('どんうさぎ')}
    tweet = tweets.first
    return if tweet.blank?
    screen_name = tweet.user.screen_name

    # TODO 共通化したい
    response = HTTP.headers('Content-Type' => "application/json")
     .post(endpoint, json: { message: tweet.text })

    messages = response.parse.with_indifferent_access[:messages]
    messages.each do |message|
      body = "#{message[:body]} #{Time.now}"
      puts "body: #{body}"
      @client.update("@#{screen_name} #{body}", in_reply_to_status_id: tweet.id)
    end
  end

  def favorite_all
    FavoriteWord.all.each { |favorite_word| favorite(favorite_word.word) }
  end

  def favorite(search_word)
    str = "#{search_word} -RT"
    puts str

    tweets = @client.search(str)
      .select{|t| t.user.screen_name != BOT_SCREEN_NAME}
      .select{|t| t.text.downcase.include?(search_word.downcase)}

    tweets.each_with_index do |tweet, index|
      next if tweet.favorited?
      break if index > 0 # 最新の1件のみを処理する(favoriteし過ぎないようにするため)

      puts tweet.text
      @client.favorite(tweet.id)
    end
  end

  def auto_tweet
    auto_tweet = AutoTweet.all.sample
    @client.update(auto_tweet.body)
  end

  def clone_tweets
    @client.user_timeline('harada4atsushi', exclude_replies: true, include_rts: false).each do |tweet|
      AutoTweet.find_or_create_by!(body: tweet.text)
    end
  end
end
