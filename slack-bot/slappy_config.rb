Slappy.configure do |config|
  ## Slappy Settings
  #
  # token:
  #   Slack API Token
  #
  # config.token = 'xoxp-134066513041-135425234518-134834764949-40b7774f2dc8ed4ef14ae2f432220592' # kozoy test token
  # config.token = 'xoxp-2849050538-2849050540-134825194533-405397c7718a49a98789b5d17c5c68bc' # mofmof team
  config.token = 'xoxb-135444176535-dz1NEZQ3O2nG168WXKSibs44' # kozoy bot api token
  # https://slack.com/api/users.list?token=xoxb-135444176535-dz1NEZQ3O2nG168WXKSibs44

  # scripts_path_dir:
  #   Slappy scripts directory.
  #   Slappy load scripts in this directory.
  #
  config.scripts_dir_path = 'slappy-scripts'

  # logger:
  #   Use logger object.
  #
  # file = File.open(File.expand_path('../log') + '/slappy.log', File::WRONLY | File::APPEND | File::CREAT)
  # file.sync = true
  # config.logger = Logger.new(file)

  # logger.level:
  #   Specify logger level.
  #
  # production = ENV['RACK_ENV'] == 'production' || ENV['RAILS_ENV'] == 'production'
  # config.logger.level = production ? Logger::INFO : Logger::DEBUG

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

  # username:
  #   Name of bot.
  #
  config.robot.username = '@myope'

  # channel:
  #   Channel, private group, or IM channel to send message to.
  #   Can be an encoded ID, or a name. See below for more details.
  #
  config.robot.channel = '#general'

  # icon_emoji:
  #   emoji to use as the icon for this message. Overrides icon_url.
  #
  # config.robot.icon_emoji = nil

  # icon_url:
  #    URL to an image to use as the icon for this message
  #
  # config.robot.icon_url = nil
end
