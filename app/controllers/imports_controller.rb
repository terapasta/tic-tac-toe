class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def new
  end

  def create
    if ImportedTrainingMessage.import_csv(params[:file], @bot)
      flash[:notice] = 'インポートしました'
      redirect_to action: :new
    else
      flash[:error] = 'インポートに失敗しました'
      render :new
    end
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    # def bot_params
    #   params.require(:bot).permit(:name, :image)
    # end
end
