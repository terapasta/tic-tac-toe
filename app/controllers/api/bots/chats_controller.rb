class Api::Bots::ChatsController < Api::BaseController
  def show
    token = params.require(:bot_token)
    @bot = Bot.find_by!(token: token)
    @chat = @bot.chats.find(params[:id])
    render json: @chat, adapter: :json
  end

  def create
    token = params.require(:bot_token)
    uid = params.require(:uid)
    service_type = params.require(:service_type)

    @bot = Bot.find_by!(token: token)

    @chat_service_user = @bot.chat_service_users.find_or_create_by(
      uid: uid,
      service_type: service_type
    )
    @chat_service_user.make_guest_key_if_needed!

    @chat_service_user.guest_key.tap do |gk|
      @chat = @bot.chats.find_or_create_by(guest_key: gk)
    end

    render json: @chat, adapter: :json, status: :created
  end
end
