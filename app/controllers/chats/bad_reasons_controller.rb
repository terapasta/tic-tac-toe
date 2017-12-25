class Chats::BadReasonsController < ApplicationController
  include GuestKeyUsable

  def create
    @bot = Bot.find_by!(token: params[:token])
    @message = @bot.messages.find(params[:message_id])
    @bad_reason = @message.bad_reasons.build(permitted_attributes(BadReason))
    @guest_user = GuestUser.find_by(guest_key: guest_key)
    @bad_reason.guest_user = @guest_user if @guest_user.present?
    if @bad_reason.save
      render json: {}, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end
end