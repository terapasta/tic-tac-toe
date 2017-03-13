class Trainings::TrainingMessagesController < ApplicationController
  include Replyable
  include BotUsable

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
    training_message.speaker = 'bot'

    if params[:parent_decision_branch_id].present?
      decision_branch = @bot.decision_branches.find_by(id: params[:parent_decision_branch_id])
      answer.parent_decision_branch = decision_branch
      training_message.learn_enabled = false
    end


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
    elsif params[:btn_update_answer_failed]
      message_update_answer_failed
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
        a.headline = training_message_params[:answer_attributes][:headline]
      end

      if @training_message.update(answer: answer, body: answer.body)
        flash[:notice] = '回答を差し替えました'
      else
        flash[:error] = '回答の差し替えに失敗しました'
      end
    end

    def message_update
      @training_message.attributes = training_message_params
      @training_message.answer.body = training_message_params[:body]
      if @training_message.save
        flash[:notice] = '回答を更新しました'
      else
        flash[:error] = '回答の更新に失敗しました'
      end
    end

    def message_update_answer_failed
      defined_answer = DefinedAnswer.classify_failed
      @training_message.answer = defined_answer
      @training_message.body = defined_answer.body
      if @training_message.save
        flash[:notice] = '回答を更新しました'
      else
        flash[:error] = '回答の更新に失敗しました'
      end
    end

    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def set_training
      @training = @bot.trainings.find(params[:training_id])
    end

    def set_training_message
      @training_message = @training.training_messages.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:answer_id, :body, answer_attributes: [:id, :headline])
    end
end
