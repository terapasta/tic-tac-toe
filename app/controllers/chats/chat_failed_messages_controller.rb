class Chats::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable
  include NotApplicableMessageHandleable

  def create
    guest_key = params.require(:guest_key)
    # Web版（chats)と外部連携API（api/bots)とでtokenの取り方が違うため条件分岐
    token = params[:token].present? ? params.require(:token) : params.require(:bot_token)
    message = params.require(:message)

    render_collection_json create_messages_for_failed(guest_key, token, message), status: :created
  end
end
