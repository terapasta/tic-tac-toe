require 'zendesk_api'

class ZendeskApiInit
  def self.client
    @client ||= ZendeskAPI::Client.new do |config|
      # Mandatory:

      config.url = ENV['ZENDESK_URL'] # e.g. https://mydesk.zendesk.com/api/v2

      # Basic / Token Authentication
      config.username = ENV['ZENDESK_USERNAME']

      # Choose one of the following depending on your authentication choice
      config.token = ENV['ZENDESK_TOKEN']
      # config.password = ENV['ZENDESK_PASSWORD']

      # OAuth Authentication
      config.access_token = ENV['ZENDESK_TOKEN_OAUTH']

      # Optional:

      # Retry uses middleware to notify the user
      # when hitting the rate limit, sleep automatically,
      # then retry the request.
      config.retry = true

      # Logger prints to STDERR by default, to e.g. print to stdout:
      require 'logger'
      config.logger = Logger.new(STDOUT)

      # Changes Faraday adapter
      # config.adapter = :patron

      # Merged with the default client options hash
      # config.client_options = { :ssl => false }

      # When getting the error 'hostname does not match the server certificate'
      # use the API at https://yoursubdomain.zendesk.com/api/v2
    end
  end
end
