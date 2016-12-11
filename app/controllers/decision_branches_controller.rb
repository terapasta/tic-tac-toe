class DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_decision_branch

  def show
    respond_to do |format|
      format.json { render json: @decision_branch.decorate.as_json }
    end
  end

  def update
    respond_to do |format|
      if @decision_branch.update(decision_branch_params)
        format.json { render json: @decision_branch.decorate.as_json }
      else
        format.json { render json: @decision_branch.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

    def set_bot
      @bot = Bot.find params[:bot_id]
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branches.find params[:id]
    end

    def decision_branch_params
      params.require(:decision_branch).permit(:answer_id, :body, :next_answer_id)
    end
end
