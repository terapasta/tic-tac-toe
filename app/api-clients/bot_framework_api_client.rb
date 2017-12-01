# Microsoft BotFramework api client
# reference: https://docs.microsoft.com/en-us/bot-framework/rest-api/bot-framework-rest-connector-authentication
class BotFrameworkApiClient
  class FailedInitializationError < StandardError; end
  class FailedAuthenticationError < StandardError; end

  def initialize
    @conn = Faraday::Connection.new(url: 'https://login.microsoftonline.com')
    if ENV['MICROSOFT_APP_ID'].blank? || ENV['MICROSOFT_APP_PASSWORD'].blank?
      fail FailedInitializationError.new('missing required env value: MICROSOFT_APP_ID and MICROSOFT_APP_PASSWORD')
    end
    @client_id = ENV['MICROSOFT_APP_ID']
    @client_secret = ENV['MICROSOFT_APP_PASSWORD']
    @auth = {}
  end

  def create_access_token!
    res = @conn.post do |req|
      req.url '/botframework.com/oauth2/v2.0/token'
      req.body = {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_secret: @client_secret,
        scope: 'https://api.botframework.com/.default'
      }
    end
    fail FailedAuthenticationError.new and return unless res.success?
    @auth = JSON.parse(res.body)
  end
end