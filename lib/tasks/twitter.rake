namespace :twitter do
  task reply: :environment do
    include Rails.application.routes.url_helpers

    client = Twitter::REST::Client.new(
      consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
      consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
      access_token:        ENV['TWITTER_ACCESS_TOKEN'],
      access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET'],
    )

    tweet_id = TwitterReply.try(:last).try(:tweet_id) || 0
    client.mentions_timeline.select{|m| m.id > tweet_id}.each do |mention|
      puts mention.text

      screen_name = mention.user.screen_name
      endpoint = api_v1_messages_url
      puts "endpoint: #{endpoint}"

      response = HTTP.headers('Content-Type' => "application/json")
       .post(endpoint, json: { message: mention.text })

      messages = response.parse.with_indifferent_access[:messages]
      messages.each do |message|
        body = "#{message[:body]} #{Time.now}"
        puts "body: #{body}"
        client.update("@#{screen_name} #{body}", in_reply_to_status_id: mention.id)
      end

      TwitterReply.create!(tweet_id: mention.id, screen_name: screen_name)
    end
  end
end
