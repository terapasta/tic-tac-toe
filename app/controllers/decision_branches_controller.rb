class DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_decision_branch, only: [:show, :update, :destroy]

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

  def create
    @decision_branch = @bot.decision_branches.build(decision_branch_params)
    respond_to do |format|
      if @decision_branch.save
        format.json { render json: @decision_branch.decorate.as_json, status: :created }
      else
        format.json { render json: @decision_branch.decorate.errors_as_json, status: :unprocessable_entity }
      end
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

  def destroy
    ActiveRecord::Base.transaction do
      @decision_branch.next_answer.try(:self_and_deep_child_answers).try(:map, &:destroy!)
      @decision_branch.destroy!
    end
    respond_to do |format|
      format.json { render json: {}, status: :no_content }
    end
  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    respond_to do |format|
      format.json { render json: { error: e.message }, status: :internal_server_error }
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
