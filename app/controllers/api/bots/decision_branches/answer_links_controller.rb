class Api::Bots::DecisionBranches::AnswerLinksController < Api::BaseController
  before_action :set_bot_and_decision_branch

  def create
    @answer_link = @decision_branch.build_answer_link(permitted_attributes(AnswerLink))
    if @answer_link.save
      render json: {}, status: :created
    else
      render_unprocessable_entity_error_json(@answer_link)
    end
  end

  def destroy
    @answer_link = @decision_branch.answer_link
    render_not_found_json and return if @answer_link.blank?
    @answer_link.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot_and_decision_branch
      @bot = Bot.find_by!(token: params[:bot_token])
      @decision_branch = @bot.decision_branches.find(params[:decision_branch_id])
    end
end