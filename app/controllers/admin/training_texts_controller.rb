class Admin::TrainingTextsController < ApplicationController
  include JudgeUserRole
  before_action :authenticate_staff_user

  def new
    @training_text = TrainingText.build_by_sample
  end

  def create
    @training_text = TrainingText.new(training_text_params)
    if @training_text.save
      redirect_to new_admin_training_text_path, notice: '登録しました。'
    else
      flash[:alert] = '登録に失敗しました。'
      render :new
    end
  end

  private
    def training_text_params
      params.require(:training_text).permit(:body, :tag_list)
    end
end
