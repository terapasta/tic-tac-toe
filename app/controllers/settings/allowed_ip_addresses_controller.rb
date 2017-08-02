class Settings::AllowedIpAddressesController < Settings::BaseController
  def show; end

  def update
    if @bot.update(permitted_attributes(@bot))
      redirect_to bot_settings_allowed_ip_addresses_path(@bot), notice: '許可IPアドレスを更新しました'
    else
      flash.now.alert = '許可IPアドレスを更新できませんでした'
      render :show
    end
  end
end
