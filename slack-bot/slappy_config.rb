require File.expand_path('../config/environment')

Slappy.configure do |config|
  ## Slappy Settings
  #
  # token:
  #   Slack API Token
  #
  config.token = ENV['SLACK_API_TOKEN']
  # you can get bot id here:
  # https://slack.com/api/users.list?token=your_token

  # scripts_path_dir:
  #   Slappy scripts directory.
  #   Slappy load scripts in this directory.
  #
  config.scripts_dir_path = 'slappy-scripts'

  # logger:
  #   Use logger object.
  #
  file = File.open(File.expand_path('../log') + '/slappy.log', File::WRONLY | File::APPEND | File::CREAT)
  file.sync = true
  config.logger = Logger.new(file)

  # logger.level:
  #   Specify logger level.
  #
  production = ENV['RACK_ENV'] == 'production' || ENV['RAILS_ENV'] == 'production'
  config.logger.level = production ? Logger::INFO : Logger::DEBUG

  # dsl:
  #   use dsl
  #
  #   param: :enabled or :disabled
  #
  # config.dsl = :enabled

  # stop_with_error:
  #   Select bot be stop when catch StandardError.
  #   If false, puts stack trace but be not stop when bot catch StandardError.
  #
  # config.stop_with_error = true

  ## Default parameters
  #
  # There parameters use in say method when send to Slack.
  # Settings specified here will take precedence over those in method option
  # And other parameters give to method option if you want.
  #
  #   Official API document:
  #     https://api.slack.com/methods/chat.postMessage

  # as_user:
  #   Pass true to post the message as the authed user (or registered custom bot user), instead of as a temporary bot.
  config.robot.as_user = true

  # username:
  #   Name of bot ,when config.robot.as_user is false.
  #
  # config.robot.username = '@donusagi_bot'

  # channel:
  #   Channel, private group, or IM channel to send message to.
  #   Can be an encoded ID, or a name. See below for more details.
  #
  config.robot.channel = '#random'

  # bot_id:
  #   Used to match pattern suffix given by respond method.
  #   This value is slack's user id.
  #   Bot name of destination in a message is converted to user id, and is compared this value.
  config.robot.bot_id = 'U2M8HFV3Q'

  # icon_emoji:
  #   emoji to use as the icon for this message. Overrides icon_url.
  #
  # config.robot.icon_emoji = nil

  # icon_url:
  #    URL to an image to use as the icon for this message, when config.robot.as_user is false
  #
  # config.robot.icon_url = nil
end
