class Api::Bots::DecisionBranchesController < Api::BaseController
  before_action :set_bot
  before_action :set_decision_branch, only: [:update, :destroy]

  def create
    @decision_branch = @bot.decision_branches.build(permitted_attributes(DecisionBranch))
    if @decision_branch.save
      render json: @decision_branch, adapter: :json, status: :created
    else
      render_unprocessable_entity_error_json(@decision_branch)
    end
  end

  def update
    if @decision_branch.update(permitted_attributes(@decision_branch))
      render json: @decision_branch, adapter: :json, status: :ok
    else
      render_unprocessable_entity_error_json(@decision_branch)
    end
  end

  def destroy
    @decision_branch.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branch.find(params[:id])
      authorize @decision_branch
    end
end
