class Settings::BotsController < Settings::BaseController

  def show; end

  def update
    if @bot.update(permitted_attributes(@bot))
      redirect_to bot_settings_bot_path(@bot), notice: 'ボット設定を更新しました'
    else
      flash.now.alert = 'ボット設定を更新できませんでした'
      render :show
    end
  end
end