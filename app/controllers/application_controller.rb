class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # layout 'lumen'

  rescue_from StandardError, with: :handle_500

  include Pundit

  private

    def handle_500(exception)
      ExceptionNotifier.notify_exception exception, env: request.env

      logger.error exception.message
      logger.error exception.backtrace.join("\n")

      render 'errors/error_500', layout: 'blank'
    end
end
