class TwitterBot
  include Rails.application.routes.url_helpers

  SEARCH_WORDS = %w(どんうさぎ はらぱんさん もふもふ はらぱんさん My-ope)
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
    tweets = @client.search(str)
      .select{|t| t.user.screen_name != BOT_SCREEN_NAME}
      .select{|t| t.user.screen_name == 'harada4atsushi'}
      .select{|t| t.text.include?('どんうさぎ')}
    tweet = tweets.first
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
    SEARCH_WORDS.each { |search_word| favorite(search_word) }
  end

  def favorite(search_word)
    str = "#{search_word} -RT"
    puts str

    tweets = @client.search(str)
      .select{|t| t.user.screen_name != BOT_SCREEN_NAME}
      .select{|t| t.text.include?(search_word)}

    tweets.each_with_index do |tweet, index|
      next if tweet.favorited?
      break if index > 0 # 最新の1件のみを処理する(favoriteし過ぎないようにするため)

      puts tweet.text
      @client.favorite(tweet.id)
    end
  end
end
