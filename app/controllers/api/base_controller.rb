class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden_json
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_json

  private
    def render_forbidden_json
      render json: { error: 'Forbidden access' }, status: :forbidden
    end

    def render_not_found_json
      render json: { error: 'Not found' }, status: :not_found
    end
end
