class BotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot, only: [:edit, :update]

  def index
    @bots = current_user.bots
  end

  def edit
  end

  def update
    if @bot.update(bot_params)
      redirect_to bots_path, notice: 'Botが更新されました'
    else
      render :edit
    end
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:id])
    end

    def bot_params
      params.require(:bot).permit(:name, :image)
    end
end
