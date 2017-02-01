require 'open-uri'
require 'json'
require File.expand_path('../config/environment')

def get_bot_id
  Slappy.configuration.token.tap do |token|
    if token.is_a?(String) && token.length > 0
      open('https://slack.com/api/users.list?token=' + token) do |res|
        data = JSON.parse(res.read)
        if data['ok']
          @bot_id = data['members'].detect{ |member| member['name'] == 'myope' }.try(:[], 'id')
        end
      end
    end
  end
end

def mention_to_me?(e)
  @bot_id != nil && e.text =~ /<@#{@bot_id}>/
end
