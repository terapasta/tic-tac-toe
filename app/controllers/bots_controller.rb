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
    if @bot.update(permitted_attributes(@bot))
      redirect_to edit_bot_path(@bot), notice: '更新しました'
    else
      flash.now.alert = '更新に失敗しました'
      render :edit
    end
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
end
