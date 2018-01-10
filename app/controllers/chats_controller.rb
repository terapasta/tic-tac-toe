class ChatsController < ApplicationController
  include IframeSupportable
  include GuestKeyUsable
  before_action :set_bot
  before_action :set_guest_key
  before_action :set_guest_user
  before_action :set_warning_message
  before_action :prepare_iframe

  class ExceededError < StandardError; end
  class FinishedTrialError < StandardError; end

  rescue_from ExceededError, with: :render_exceeded_page
  rescue_from FinishedTrialError, with: :render_finished_trial_page

  def show
    @chat = @bot.chats.where(guest_key: guest_key).order(created_at: :desc).first
    if @chat.nil?
      redirect_to new_chats_path(token: params[:token], noheader: params[:noheader])
    else
      authorize @chat
    end
  end

  def new
    @chat = @bot.chats.create_by(guest_key: guest_key) do |chat|
      authorize chat
      chat.is_staff = true if current_user.try(:staff?)
      chat.is_normal = true if current_user.try(:normal?)
    end
    render :show
  end

  private
    def set_bot
      @bot = Bot.find_by!(token: params[:token])
    end

    def set_warning_message
      return false unless @bot.id == 2  # botがハナコさんのときのみデモ情報を表示する
      flash.now[:warning] = "本デモでは以下のオペレーションに対して回答することが出来ます。\n・カードキーなくした\n・パソコンが壊れた、ログインができない\n・今週の予定どうなってますか？\n・総務の山田さんに連絡をとりたい"
    end

    def set_guest_user
      @guest_user = GuestUser.find_by(guest_key: guest_key)
    end

    def prepare_iframe
      iframe_support @bot
      fail ExceededError.new if policy(@bot).exceeded_chats_count?
      fail FinishedTrialError if policy(@bot).finished_trial?
    end

    def render_exceeded_page
      render :exceeded, status: :too_many_requests
    end

    def render_finished_trial_page
      render :finished_trial, status: :service_unavailable
    end
end
