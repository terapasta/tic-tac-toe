class BotsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot, only: [:edit, :update, :reset]

  def index
    @bots = bots.all
  end

  def edit
  end

  def update
    if @bot.update(bot_params)
      flash[:notice] = '更新しました'
    else
      flash[:notice] = '更新に失敗しました'
    end
    render :edit
  end

  def reset
    @bot.reset_training_data!
    flash[:notice] = '学習データをリセットしました'
    redirect_to [:edit, @bot]
  end

  private
    def set_bot
      @bot = bots.find(params[:id])
      authorize @bot
    end

    def bot_params
      params.require(:bot).permit(:name, :image, :classify_failed_message, :start_message)
    end
end
