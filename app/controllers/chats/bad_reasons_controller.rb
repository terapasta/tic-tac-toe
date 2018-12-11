class Chats::BadReasonsController < ApplicationController
  include GuestKeyUsable

  # 対応ストーリー
  # https://www.pivotaltracker.com/n/projects/1879711/stories/162299167
  #
  # csrf-token が一致しない場合は session を無効化することで CSRF対策をする
  protect_from_forgery with: :null_session

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