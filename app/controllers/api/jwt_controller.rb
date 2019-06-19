class Api::JwtController < Api::BaseController
  def show
    render json: 'test'
  end
end