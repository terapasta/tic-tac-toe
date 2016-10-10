require 'slack'

namespace :slack do
  task listen: :environment do
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    auth = Slack.auth_test
    user_id = auth['user_id']

    client = Slack.realtime

    client.on :hello do
      puts 'Successfully connected.'
    end

    client.on :message do |data|
      if data['subtype'] != 'bot_message' && data['text'].include?("@#{user_id}") && data['user'] != user_id
        text = data['text'].delete("<@#{user_id}> ")

        endpoint = Rails.application.routes.url_helpers.api_v1_messages_url
        response = HTTP.headers('Content-Type' => "application/json")
         .post(endpoint, json: { message: text, bot_id: 1 })  # TODO bot_idを指定できるようにする

        messages = response.parse.with_indifferent_access[:messages]
        messages.each do |message|
          body = "#{message[:body]}"

          params = {
            token: ENV['SLACK_API_TOKEN'],
            channel: data['channel'],
            text: "<@#{data['user']}> #{body}",
            as_user: true,
          }
          Slack.chat_postMessage params
        end
      end
    end

    client.start
  end
end