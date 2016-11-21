class Admin::TrainingTextsController < ApplicationController
  before_action :authenticate_admin_user!
  #
  # before_action :set_bot
  # before_action :set_answer, only: [:edit, :update, :destroy]
  #
  # def index
  #   @answers = @bot.answers.order('id desc').page(params[:page])
  # end
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

  # def destroy
  #   @answer.destroy!
  #
  #   redirect_to bot_answers_path(@bot), notice: '回答を削除しました。'
  # end
  #
  private
    # def set_training_text
    #   @bot = TrainingText.
    # end

  #   def set_answer
  #     @answer = @bot.answers.find params[:id]
  #   end
  #
    def training_text_params
      params.require(:training_text).permit(:body, :tag_list)
    end
end
