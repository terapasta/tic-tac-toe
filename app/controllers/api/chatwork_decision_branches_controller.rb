class Api::ChatworkDecisionBranchesController < Api::BaseController
  def show
    @chatwork_decision_branch = ChatworkDecisionBranch.find_by!(access_token: params[:access_token])
    @decision_branch = @chatwork_decision_branch.decision_branch
    @bot = @chatwork_decision_branch.bot
    @chat = @chatwork_decision_branch.chat
    ChatworkDecisionBranchJob.perform_later(@bot, @chat, @decision_branch, @chatwork_decision_branch)

    render template: 'api/chatwork_decision_branches/show.html.slim'
  end

  def create
    @chatwork_decision_branch = ChatworkDecisionBranch.new(chatwork_decision_branch_params)
    if @chatwork_decision_branch.save
      render json: @chatwork_decision_branch, adapter: :json, status: :created
    else
      render_unprocessable_entity_error_json(@chatwork_decision_branch)
    end
  end

  private
    def chatwork_decision_branch_params
      params.require(:chatwork_decision_branch).permit(
        :decision_branch_id,
        :chat_id,
        :room_id,
        :from_account_id
      )
    end
end
