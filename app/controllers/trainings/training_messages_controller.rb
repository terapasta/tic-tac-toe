class Trainings::TrainingMessagesController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_training_message, only: [:update, :destroy]

  def create
    answer = @bot.answers.find_or_create_by!(body: training_message_params[:body]) do |a|
      a.context = 'normal'
    end

    training_message = @training.training_messages.build(training_message_params)
    training_message.answer = answer

    if training_message.save
      flash[:notice] = '回答を差し替えました'
    else
      flash[:error] = '回答の差し替えに失敗しました'
    end

    if auto_mode?
      guest_message = @training.training_messages.build(@bot.messages.guest.sample.to_training_message_attributes)
      receive_and_reply!(@training, guest_message)
    end

    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
  end

  def update
    if params[:btn_replace]
      message_replace
    elsif params[:btn_update]
      message_update
    end

    if auto_mode?
      @training.training_messages.build(@bot.messages.guest.sample.to_training_message_attributes)
      receive_and_reply!(@training, @guest_message)
    end

    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
  end

  def destroy
    training_messages = @training.training_messages.where('id >= ?', @training_message.id)
    if training_messages.destroy_all
      @training_message.destroy_parent_decision_branch_relation!
      training_message = @training.training_messages.build(speaker: 'guest')
      flash[:notice] = '回答を削除しました'
    else
      flash[:error] = '回答の削除に失敗しました'
    end
    redirect_to bot_training_path(@bot, @training)
  end

  private
    def message_replace
      answer = @bot.answers.find_or_create_by!(body: training_message_params[:body]) do |a|
        a.context = 'normal'
      end

      if @training_message.update(answer: answer, body: answer.body)
        flash[:notice] = '回答を差し替えました'
      else
        flash[:error] = '回答の差し替えに失敗しました'
      end
    end

    def message_update
      @training_message.answer.body = training_message_params[:body]
      if @training_message.update(body: training_message_params[:body])
        flash[:notice] = '回答を更新しました'
      else
        flash[:error] = '回答の更新に失敗しました'
      end
    end

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
