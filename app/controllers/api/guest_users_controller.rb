class Api::GuestUsersController < Api::BaseController
  include GuestKeyUsable
  before_action :set_guest_user, only: [:show, :update, :destroy]

  def show
    render json: @guest_user, adapter: :json
  end

  def create
    @guest_user = GuestUser.new(permitted_attributes(GuestUser).merge(
      guest_key: guest_key
    ))
    if @guest_user.save
      render json: @guest_user, adapter: :json, status: :created
    else
      render_unprocessable_entity_error_json(@guest_user)
    end
  end

  def update
    if @guest_user.update(permitted_attributes(@guest_user))
      render json: @guest_user, adapter: :json, status: :ok
    else
      render_unprocessable_entity_error_json(@guest_user)
    end
  end

  def destroy
    @guest_user.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_guest_user
      @guest_user = GuestUser.find_by!(guest_key: params[:guest_key])
    end
end
