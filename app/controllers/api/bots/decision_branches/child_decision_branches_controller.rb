class Api::Bots::DecisionBranches::ChildDecisionBranchesController < Api::BaseController
  before_action :set_bot
  before_action :set_decision_branch

  def destroy
    @decision_branch.child_decision_branches.map(&:destroy!)
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branches.find(params[:decision_branch_id])
      authorize @decision_branch
    end
end
