class Api::Bots::ChatFailedMessagesController < Api::BaseController
  include ApiRespondable
  include NotApplicableMessageHandleable

  def create
    guest_key = params.require(:guest_key)
    # Web版（chats)と外部連携API（api/bots)とでtokenの取り方が違うため条件分岐
    token = params[:token].present? ? params.require(:token) : params.require(:bot_token)
    message = params.require(:message)

    _, bot_message = *create_messages_for_failed(guest_key, token, message)

    respond_to do |format|
      format.json { render json: bot_message, adapter: :json }
    end
  end
end
