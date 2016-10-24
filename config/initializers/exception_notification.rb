require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  config.ignored_exceptions += %w{ActionView::TemplateError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    not Rails.env.production?
  end

  # Notifiers =================================================================

  config.add_notifier :slack, {
    webhook_url: ENV['SLACK_WEBHOOK_URL'],
    channel: "#my-ope-exception",
    additional_parameters: { mrkdwn: true, icon_emoji: ":ghost:" }
  }
end
