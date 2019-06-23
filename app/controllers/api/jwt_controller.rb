class Api::JwtController < Api::BaseController
  def show
    token = Jwt.generate(current_user)
    render json: { token: token }
  end
end