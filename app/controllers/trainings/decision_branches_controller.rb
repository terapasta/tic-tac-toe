class Trainings::DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_models, only: [:new, :update]
  before_action :set_decision_branch, only: :update

  def new
    @decision_branch = @answer.decision_branches.build
  end

  def create
  end

  def update
    @decision_branch.update(decision_branch_params)
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
