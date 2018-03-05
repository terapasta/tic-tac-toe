class Api::Bots::DecisionBranches::PositionsController < Api::BaseController
  before_action :set_bot
  before_action :set_decision_branch, only: [:higher, :lower]

  def higher
    @decision_branch.move_higher
    render json: @decision_branch, adapter: :json
  end

  def lower
    @decision_branch.move_lower
    render json: @decision_branch, adapter: :json
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branches.find(params[:decision_branch_id])
      authorize @decision_branch, :update?
    end
end