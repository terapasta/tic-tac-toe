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
      if data['subtype'] != 'bot_message' && data['text'].include?("@#{user_id}")
        params = {
          token: ENV['SLACK_API_TOKEN'],
          channel: data['channel'],
          text: "おやすみ",
          as_user: true,
        }
        Slack.chat_postMessage params
      end
    end

    client.start
  end
end
