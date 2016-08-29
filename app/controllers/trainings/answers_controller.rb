class Trainings::AnswersController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_answer, only: [:update]

  def replace
    answer = @bot.answers.find_or_create_by!(body: answer_params[:body]) do |a|
      a.context = 'normal'
    end
    training_message = TrainingMessage.find(params[:id])
    training_message.update!(answer_id: answer.id, body: answer.body)

    if auto_mode?
      auto_training_message = @training.training_messages.build(Message.guest.sample.to_training_message_attributes)
      receive_and_reply!(@training, auto_training_message)
    end

    redirect_to bot_training_path(@bot, @training, auto: params[:auto]), notice: '回答を差し替えました'
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = '回答を更新しました'

      if auto_mode?
        auto_training_message = @training.training_messages.build(Message.guest.sample.to_training_message_attributes)
        receive_and_reply!(@training, auto_training_message)
      end
    else
      flash[:notice] = '回答の更新に失敗しました'
    end
    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
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
