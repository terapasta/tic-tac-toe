class Trainings::DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_models
  before_action :set_decision_branch, only: [:update, :destroy, :choice]

  def new
    @decision_branch = @answer.decision_branches.create!(bot_id: @bot.id)
  end

  def create
    @decision_branch = @answer.decision_branches.build(decision_branch_params)
    @decision_branch.bot_id = @bot.id
    @decision_branch.save
  end

  def update
    @decision_branch.update(decision_branch_params)
  end

  def destroy
    @decision_branch.destroy
    render nothing: true
  end

  def choice
    @guest_training_message = @training.training_messages.build(speaker: :guest, body: @decision_branch.body)
    @training.save!

    message = @training.training_messages.build(speaker: :bot)
    if @decision_branch.next_answer.present?
      message.answer = @decision_branch.next_answer
      message.body = message.answer.body
      @training.save!
    else
      message.build_answer(parent_decision_branch: @decision_branch)
      # message.body = ''
    end
    # binding.pry
    # redirect_to bot_training_path(@bot, @training, auto: params[:auto])
    render 'trainings/show'
  end

  private
    def set_models
      @bot = current_user.bots.find(params[:bot_id])
      @training = @bot.trainings.find(params[:training_id])
      @answer = @bot.answers.find(params[:answer_id])
    end

    def set_decision_branch
      @decision_branch = @answer.decision_branches.find(params[:id])
    end

    def decision_branch_params
      params.require(:decision_branch).permit(:body)
    end
end
