class Settings::ResetsController < Settings::BaseController
  def show; end

  def create
    authorize @bot, :reset?
    @bot.reset_training_data!
    redirect_to bot_settings_reset_path(@bot), notice: '学習データをリセットしました'
  end
end
