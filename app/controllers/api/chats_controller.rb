class Api::ChatsController < Api::BaseController
  skip_before_action :authenticate_user!

  def create
    token = params.require(:token)
    uid = params.require(:uid)
    service_type = params.require(:service_type)

    @bot = Bot.find_by!(token: params[:token])

    @chat_service_user = @bot.chat_service_users.find_or_create_by(
      uid: uid,
      service_type: service_type
    )
    @chat_service_user.make_guest_key_if_needed!

    @chat_service_user.guest_key.tap do |gk|
      @chat = @bot.chats.find_by(guest_key: gk)
      @chat = @bot.chats.create_by(guest_key: gk) if @chat.nil?
    end

    render json: @chat, adapter: :json, status: :created
  end
end
