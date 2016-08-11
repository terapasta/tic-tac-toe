class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot, only: [:new]
  before_action :set_training, only: [:show, :create, :destroy]

  def show
  end

  def new
    @training = @bot.trainings.new
    @training.training_messages << TrainingMessage.start_message
    if @training.save
      flash[:notice] = '新しいスレッドが開始されました'
    else
      flash[:notice] = '新しいスレッドの開始に失敗しました'
    end
    render :show
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = Training.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
