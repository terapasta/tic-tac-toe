class Trainings::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_answer, only: [:update]

  def replace
    answer = @bot.answers.create!(answer_params.merge(context: 'normal'))
    training_message = TrainingMessage.find(params[:id])
    training_message.update!(answer_id: answer.id, body: answer.body)
    redirect_to bot_training_path(@bot, @training), notice: '回答を差し替えました'
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = '回答を更新しました'
    else
      flash[:notice] = '回答の更新に失敗しました'
    end
    redirect_to bot_training_path(@bot, @training)
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_training
      @training = Training.find(params[:training_id])
    end

    def answer_params
      params.require(:answer).permit(:body)
    end

    def training_message_params
      params.require(:training_message).permit(:answer_id)
    end
end
