class Trainings::AnswersController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_answer, only: [:update]

  # def new
  #   decision_branch = @bot.decision_branches.find(params[:decision_branch_id])
  #   @training.training_messages.build(speaker: :guest, body: decision_branch.body)
  #   @training.save!
  #
  #   message = @training.training_messages.build(speaker: :bot)
  #   if decision_branch.next_answer.present?
  #     message.answer = decision_branch.next_answer
  #     message.body = message.answer.body
  #     @training.save!
  #   else
  #     message.build_answer(parent_decision_branch: decision_branch)
  #   end
  #   render 'trainings/show'
  # end

  def edit
    @message = @training.training_messages.build(answer_id: params[:id])
    @message.speaker = 'bot'
    @message.save!
    render :new
  end

  def create
    parent_decision_branch = @bot.decision_branches.find(params[:parent_decision_branch_id])
    message = @training.training_messages.build(speaker: :bot)
    answer = message.build_answer(answer_params)
    answer.bot_id = @bot.id
    answer.parent_decision_branch = parent_decision_branch
    message.body = answer.body
    message.save!
    flash[:notice] = '回答を差し替えました'
    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_answer
      @answer = @bot.answers.find(params[:id])
    end

    def set_training
      @training = Training.find(params[:training_id])
    end

    def answer_params
      params.require(:answer).permit(:body, decision_branches_attributes: [:id, :body, :_destroy])
    end
end
