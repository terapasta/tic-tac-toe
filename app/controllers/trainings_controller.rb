class TrainingsController < ApplicationController
  before_action :set_training, only: [:show, :edit, :update, :destroy]

  # GET /trainings
  def index
    @trainings = Training.all
  end

  # GET /trainings/1
  def show
  end

  # GET /trainings/new
  def new
    @training = Training.new
  end

  # GET /trainings/1/edit
  def edit
  end

  # POST /trainings
  def create
    @training = Training.new(training_params)

    if @training.save
      redirect_to trainings_path, notice: 'Trainingが作成されました'
    else
      render :new
    end
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
    # Use callbacks to share common setup or constraints between actions.
    def set_training
      @training = Training.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def training_params
      params[:training]
    end
end
