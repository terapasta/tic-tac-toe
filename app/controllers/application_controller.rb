class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # layout 'lumen'

  rescue_from StandardError, with: :handle_500 if Rails.env.production?
  rescue_from Pundit::NotAuthorizedError, with: :handle_403
  before_action :inject_request_to_application_policy
  before_action :set_notification

  include Pundit

  private

    def handle_500(exception)
      ExceptionNotifier.notify_exception exception, env: request.env

      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      render 'errors/error_500', layout: false, status: 500
    end

    def handle_403(exception)
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      render file: 'public/403.html', layout: false, status: 403
    end

    def after_sign_in_path_for(resource)
      if resource.try(:worker?)
        new_imported_sentence_synonym_path
      else
        super
      end
    end

    def inject_request_to_application_policy
      _request = @_request
      ApplicationPolicy.send(:define_method, :request, -> { _request })
    end

    def set_notification
      request.env['exception_notifier.exception_data'] = {
        remote_ip: request.remote_ip,
        user_agent: request.user_agent,
      }
    end

    def current_page
      (params[:page].presence || 1).to_i
    end
end
