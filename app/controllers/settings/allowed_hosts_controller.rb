class Settings::AllowedHostsController < Settings::BaseController
  def show; end

  def update
    authorize @bot
    if @bot.update(permitted_attributes(@bot))
      redirect_to bot_settings_allowed_hosts_path(@bot), notice: '許可ホストを更新しました'
    else
      flash.now.alert = '許可ホストを更新できませんでした'
      render :index
    end
  end
end
