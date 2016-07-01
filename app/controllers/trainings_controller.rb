class TrainingsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_training, only: [:show, :create]

  def show
  end

  def edit
  end

  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'
    training_message.save!
    render :show
  end

  # PATCH/PUT /trainings/1
  def update
    if @training.update(training_params)
      redirect_to trainings_path, notice: 'Trainingが更新されました'
    else
      render :edit
    end
  end

  # DELETE /trainings/1
  def destroy
    @training.destroy
    redirect_to trainings_url, notice: 'Trainingが削除されました'
  end

  private
    def set_training
      @training = Training.last || Training.create
    end

    # Only allow a trusted parameter "white list" through.
    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
