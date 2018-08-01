class Settings::PasswordsController < Settings::BaseController
  def show
  end

  def update
    if @bot.update(params.require(:bot).permit(:password))
      redirect_to bot_settings_password_path(@bot), notice: 'チャット画面パスワードを更新しました'
    else
      flash.now.alert = 'チャット画面パスワードを更新できませんでした'
      render :show
    end
  end
end