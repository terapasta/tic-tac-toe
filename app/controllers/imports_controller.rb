# FIXME メンテ工数を減らすために一旦使わない
class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def new
  end

  def create
    DataImporter.import(params[:file], @bot)
    flash[:notice] = '登録しました'
    render :new
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    # def bot_params
    #   params.require(:bot).permit(:name, :image)
    # end
end
