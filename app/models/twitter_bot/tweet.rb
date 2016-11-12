class TwitterBot::Tweet
  include Rails.application.routes.url_helpers

  BOT_SCREEN_NAME = 'donusagi_bot'

  def initialize(client, tweet, bot)
    @client = client
    @tweet = tweet
    @bot = bot
  end

  def replied?
    max_replied_tweet_id = TwitterReply.maximum(:tweet_id) || 0
    @tweet.id <= max_replied_tweet_id
  end

  def self_tweet?
    @tweet.user.screen_name == BOT_SCREEN_NAME
  end

  def reply
    screen_name = @tweet.user.screen_name
    TwitterReply.create!(bot_id: @bot.id, tweet_id: @tweet.id, screen_name: screen_name)

    response = HTTP.headers('Content-Type' => "application/json")
     .post(api_v1_messages_url, json: { message: trimmed_tweet_body, bot_id: @bot.id, guest_key: @tweet.user.id })

    messages = response.parse.with_indifferent_access[:messages]
    messages.each do |message|
      body = "#{message[:body]}#{'　' * rand(8)}" # 同一ツイート対策のため全角スペースを0〜7個追加する
      puts "body: #{body}"
      @client.update("@#{screen_name} #{body}", in_reply_to_status_id: @tweet.id)
    end
  end

  def trimmed_tweet_body
    @tweet.text.delete("@#{BOT_SCREEN_NAME} ")  # FIXME 複数宛メンションに対応するためには@から半角スペースまでを除去する必要がある
  end
end
