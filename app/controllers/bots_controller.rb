class BotsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot, only: [:show, :edit, :update, :reset]

  def index
    @bots = bots.all
    redirect_to edit_bot_path(@bots.first) if @bots.count == 1
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
