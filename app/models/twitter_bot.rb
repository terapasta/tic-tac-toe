class TwitterBot
  include Rails.application.routes.url_helpers

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
    tweet_id = TwitterReply.try(:last).try(:tweet_id) || 0
    @client.mentions_timeline.select{|m| m.id > tweet_id}.each do |mention|
      next if mention.user.screen_name == BOT_SCREEN_NAME
      puts mention.text
      screen_name = mention.user.screen_name
      TwitterReply.create!(tweet_id: mention.id, screen_name: screen_name)

      endpoint = api_v1_messages_url
      puts "endpoint: #{endpoint}"

      response = HTTP.headers('Content-Type' => "application/json")
       .post(endpoint, json: { message: mention.text })

      messages = response.parse.with_indifferent_access[:messages]
      messages.each do |message|
        body = "#{message[:body]} #{Time.now}"
        puts "body: #{body}"
        @client.update("@#{screen_name} #{body}", in_reply_to_status_id: mention.id)
      end

    end
  end

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
end
