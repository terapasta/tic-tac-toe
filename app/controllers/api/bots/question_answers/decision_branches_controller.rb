class Api::Bots::QuestionAnswers::DecisionBranchesController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer
  before_action :set_decision_branch, only: [:update, :destroy]

  def create
    @decision_branch = @question_answer.decision_branches.build(permitted_attributes(DecisionBranch).merge(bot_id: @bot.id))
    authorize @decision_branch
    if @decision_branch.save
      render json: @decision_branch, adapter: :json, status: :created, includes: 'child_decision_branches'
    else
      render json: { errors: @decision_branch.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @decision_branch.update(permitted_attributes(@decision_branch))
      render json: @decision_branch, adapter: :json, status: :ok
    else
      render json: { errors: @decision_branch.errors.full_messages }, status: :unprocessable_entity
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

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:question_answer_id])
      authorize @question_answer, :show?
    end

    def set_decision_branch
      @decision_branch = @question_answer.decision_branches.find(params[:id])
      authorize @decision_branch
    end
end
