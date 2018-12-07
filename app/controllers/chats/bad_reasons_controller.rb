class Chats::BadReasonsController < ApplicationController
  include GuestKeyUsable

  # FIXME:
  # X-CSRF-Token をヘッダに含んでいるが、iOS Safari でサードパーティ製Cookie を
  # 登録できないために、session が張れず、検証結果が true にならない
  #
  # 対応ストーリー
  # https://www.pivotaltracker.com/n/projects/1879711/stories/162299167
  #
  # Rails
  # https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L295-L297
  #
  skip_before_action :verify_authenticity_token

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