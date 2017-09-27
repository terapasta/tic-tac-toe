class Api::GuestUsersController < Api::BaseController
  skip_before_action :authenticate_user!
  before_action :set_guest_user, only: [:show, :update, :destroy]

  def show
    render json: @guest_user, adapter: :json
  end

  def create
    @guest_user = GuestUser.new(permitted_attributes(GuestUser).merge(
      guest_key: cookies.encrypted[:guest_key]
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
      authorize @guest_user
    end
end
