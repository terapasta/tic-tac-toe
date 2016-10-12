class Trainings::TrainingMessagesController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_training_message, only: [:update, :destroy]

  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'
    receive_and_reply!(@training, training_message)
    redirect_to bot_training_path(@bot, @training)
  end

  def update
    answer = Answer.find(training_message_params[:answer_id])
    if training_message.update(answer_id: training_message_params[:answer_id], body: answer.body)
      flash[:notice] = '回答を差し替えました'
    else
      flash[:error] = '回答の差し替えに失敗しました'
    end

    if auto_mode?
      auto_training_message = @training.training_messages.build(Message.guest.sample.to_training_message_attributes)
      receive_and_reply!(@training, auto_training_message)
    end

    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
  end

  def destroy
    if @training_message.destroy
      training_message = @training.training_messages.build(speaker: 'guest')
      flash[:notice] = '回答を削除しました'
    else
      flash[:error] = '回答の削除に失敗しました'
    end
    redirect_to bot_training_path(@bot, @training)
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = @bot.trainings.find(params[:training_id])
    end

    def set_training_message
      @training_message = @training.training_messages.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:answer_id, :body)
    end
end
