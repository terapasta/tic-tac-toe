class Settings::BotsController < Settings::BaseController

  def show; end

  def update
    ActiveRecord::Base.transaction do
      @bot.assign_attributes(permitted_attributes(@bot))
      @bot.save!
      if @bot.tutorial
        @bot.tutorial.edit_bot_profile = true
        @bot.tutorial.save!
      end
    end
    redirect_to bot_settings_bot_path(@bot), notice: 'ボット設定を更新しました'
  rescue
    flash.now.alert = 'ボット設定を更新できませんでした'
    render :show
  end
end
