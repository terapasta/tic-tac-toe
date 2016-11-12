class TwitterBot::Reply < TwitterBot::Base
  include Rails.application.routes.url_helpers

  def all
    bot = ::Bot.find(1)  # HACK Twitter機能ONのbotのみ動作させる(一旦固定値)
    @client.mentions_timeline.reverse_each do |mention|
      tweet = TwitterBot::Tweet.new(@client, mention, bot)
      next if tweet.replied?
      next if tweet.self_tweet?

      tweet.reply
    end
  end

  def auto
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

    # FIXME 共通化したい
    response = HTTP.headers('Content-Type' => "application/json")
     .post(endpoint, json: { message: tweet.text })

    messages = response.parse.with_indifferent_access[:messages]
    messages.each do |message|
      body = "#{message[:body]} #{Time.now}"
      puts "body: #{body}"
      @client.update("@#{screen_name} #{body}", in_reply_to_status_id: tweet.id)
    end
  end
end
