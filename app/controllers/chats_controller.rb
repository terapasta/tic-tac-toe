class ChatsController < ApplicationController
  include IframeSupportable
  before_action :set_bot, only: [:show, :new]
  before_action :set_guest_key
  before_action :set_warning_message

  def show
    iframe_support @bot
    @chat = @bot.chats.find_last_by(session[:guest_key])
    if @chat.nil?
      redirect_to new_chats_path(token: params[:token])
    else
      authorize @chat
    end
  end

  def new
    iframe_support @bot
    @chat = @bot.chats.new(guest_key: session[:guest_key])
    authorize @chat
    @chat.is_staff = true if current_user.try(:staff?) # ログインしてなくてもチャットできるため
    @chat.is_normal = true if current_user.try(:normal?)
    @chat.build_start_message
    @chat.save!
    render :show
  end

  private
    def set_bot
      @bot = Bot.find_by!(token: params[:token])
    end

    def set_guest_key
      session[:guest_key] ||= SecureRandom.hex(64)
    end

    def set_warning_message
      return false unless @bot.id == 2  # botがハナコさんのときのみデモ情報を表示する
      flash.now[:warning] = "本デモでは以下のオペレーションに対して回答することが出来ます。\n・カードキーなくした\n・パソコンが壊れた、ログインができない\n・今週の予定どうなってますか？\n・総務の山田さんに連絡をとりたい"
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
