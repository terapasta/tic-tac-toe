class Api::BaseController < ApplicationController
  include Pundit
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden_json
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_json
  rescue_from StandardError, with: :render_internal_server_error_json

  private
    def render_forbidden_json
      render json: { error: 'Forbidden access' }, status: :forbidden
    end

    def render_not_found_json
      render json: { error: 'Not found' }, status: :not_found
    end

    def render_internal_server_error_json(e)
      logger.error e.inspect
      logger.error e.backtrace.join("\n")
      render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
end
