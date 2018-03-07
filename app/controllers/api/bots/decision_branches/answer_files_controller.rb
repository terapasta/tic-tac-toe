class Api::Bots::DecisionBranches::AnswerFilesController < Api::BaseController
  before_action :set_bot
  before_action :set_decision_branch

  def create
    @answer_file = @decision_branch.answer_files.build(permitted_attributes(AnswerFile))
    if @answer_file.save
      render json: @answer_file, adapter: :json, status: 201
    else
      render_unprocessable_entity_error_json(@answer_file)
    end
  end

  def destroy
    @answer_file = @decision_branch.answer_files.find(params[:id])
    @answer_file.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :update?
    end

    def set_decision_branch
      @decision_branch = @bot.decision_branches.find(params[:decision_branch_id])
      authorize @decision_branch, :update?
    end
end