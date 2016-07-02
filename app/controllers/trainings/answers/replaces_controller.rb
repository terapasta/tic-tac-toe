class Trainings::Answers::ReplacesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_answer, only: [:update]

  def update
    training_message = TrainingMessage.find(params[:id])
    training_message.update!(answer_id: training_message_params[:answer_id])
    redirect_to trainings_path, notice: '回答を差し替えました'
  end

  # def update
  #   if @answer.update(answer_params)
  #     flash[:notice] = '回答を更新しました'
  #   else
  #     flash[:notice] = '回答の更新に失敗しました'
  #   end
  #   redirect_to trainings_path
  # end
  #
  # def destroy
  #   @training.destroy
  #   redirect_to trainings_url, notice: 'Trainingが削除されました'
  # end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

    def training_message_params
      params.require(:training_message).permit(:answer_id)
    end
end
