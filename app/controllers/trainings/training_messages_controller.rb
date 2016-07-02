class Trainings::TrainingMessagesController < ApplicationController
  before_action :authenticate_admin_user!
  # before_action :set_answer, only: [:update]
  #
  def update
    training_message = TrainingMessage.find(params[:id])
    answer = Answer.find(training_message_params[:answer_id])
    if training_message.update(answer_id: training_message_params[:answer_id], body: answer.body)
      flash[:notice] = '回答を差し替えました'
    else
      flash[:notice] = '回答の差し替えに失敗しました'
    end
    redirect_to trainings_path
  end

  private
  #   def set_answer
  #     @answer = Answer.find(params[:id])
  #   end
  #
  #   def answer_params
  #     params.require(:answer).permit(:body)
  #   end
  #
    def training_message_params
      params.require(:training_message).permit(:answer_id)
    end
end
