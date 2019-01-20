module ChatOperable
  extend ActiveSupport::Concern
  include IframeSupportable
  include GuestKeyUsable

  included do
    rescue_from IframeSupportable::ExceededError, with: :render_exceeded_page
    rescue_from IframeSupportable::FinishedTrialError, with: :render_finished_trial_page
  end

  def auth
    set_bot
    pass = params.require(:bot).require(:password)
    if @bot.password.present? && pass == @bot.password
      session[:user_inputted_password] = pass
      redirect_to chat_path
    else
      flash.now.alert = 'パスワードが正しくありません'
      render_password_view
    end
  rescue ActionController::ParameterMissing => e
    flash.now.alert = 'パスワードを入力してください'
    render_password_view
  end

  private
    def set_bot
      @bot = Bot.find_by!(token: params[:token])
      prepare_iframe(@bot)
    end

    def set_warning_message
      return false unless @bot.id == 2  # botがハナコさんのときのみデモ情報を表示する
      flash.now[:warning] = "本デモでは以下のオペレーションに対して回答することが出来ます。\n・カードキーなくした\n・パソコンが壊れた、ログインができない\n・今週の予定どうなってますか？\n・総務の山田さんに連絡をとりたい"
    end

    def set_guest_user
      @guest_user = GuestUser.find_by(guest_key: guest_key)
    end

    def render_exceeded_page
      render :exceeded, status: :too_many_requests
    end

    def render_finished_trial_page
      render :finished_trial, status: :service_unavailable
    end

    def need_password_view?
      @bot.password.present? && session[:user_inputted_password] != @bot.password
    end

    def render_password_view
      session.delete(:user_inputted_password)
      render template: 'chats/password'
    end

    def chat_path
      fail 'You must implement chat_path method'
    end
end