# Microsoft BotFramework api client
# reference: https://docs.microsoft.com/en-us/bot-framework/rest-api/bot-framework-rest-connector-authentication
class BotFrameworkApiClient
  def initialize
    @conn = Faraday.new(url: 'https://login.microsoftonline.com') do |faraday|
      faraday.request :url_encoded
      # faraday.response :logger
    end
  end

  def create_access_token
    @conn.post do |req|
      req.url '/botframework.com/oauth2/v2.0/token'
      req.params = {
        grant_type: 'client_credentials',
        client_id: ENV['MICROSOFT_APP_ID'],
        client_secret: ENV['MICROSOFT_APP_PASSWORD'],
        scope: 'https://api.botframework.com/.default'
      }
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.headers['Content-Length'] = '0'
    end
  end
end
