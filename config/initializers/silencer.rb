require 'silencer/logger'

Rails.application.configure do
  config.middleware.swap Rails::Rack::Logger, Silencer::Logger, silence: [
    /^\/bots\/[0-9]+\/learning\.json$/
  ]
end
