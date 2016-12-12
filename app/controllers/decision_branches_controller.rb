class DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_decision_branch, only: [:show, :update]

  def index
    respond_to do |format|
      @answer = @bot.answers.find_by(id: params[:answer_id])
      @decision_branches = @answer.try(:decision_branches) || @bot.decision_branches
      format.json { render json: @decision_branches.decorate.map(&:as_json) }
    end
  end

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

  private

    def set_bot
      @bot = current_user.bots.find params[:bot_id]
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branches.find params[:id]
    end

    def decision_branch_params
      params.require(:decision_branch).permit(:answer_id, :body, :next_answer_id)
    end
end
