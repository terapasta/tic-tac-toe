class Trainings::DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_decision_branch

  def create
  end

  def update
    @decision_branch.update(decision_branch_params)
  end

  private
    def set_decision_branch
      bot = current_user.bots.find(params[:bot_id])
      answer = bot.answers.find(params[:answer_id])
      @decision_branch = answer.decision_branches.find(params[:id])
    end
    # def set_bot
    #   @bot = current_user.bots.find(params[:bot_id])
    # end
    #
    # def set_training
    #   @training = Training.find(params[:training_id])
    # end

    def decision_branch_params
      params.require(:decision_branch).permit(:body)
    end
end
