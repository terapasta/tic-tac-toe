class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def new
  end

  def create
    is_success, @error_row = ImportedTrainingMessage.import_csv(params[:file], @bot)
    if is_success
      flash[:notice] = 'インポートしました'
    else
      flash[:error] = 'インポートに失敗しました'
    end
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
