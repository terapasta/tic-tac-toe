class TrainingsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_training, only: [:show, :create, :destroy]

  def show
  end

  def new
    @training = Training.new
    @training.training_messages << TrainingMessage.start_message
    if @training.save
      flash[:notice] = '新しいスレッドが開始されました'
    else
      flash[:notice] = '新しいスレッドの開始に失敗しました'
    end
    render :show
  end

  # def destroy
  #   @training.destroy
  #   render :show
  # end

  private
    def set_training
      @training = Training.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
