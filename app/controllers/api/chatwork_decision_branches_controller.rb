class Api::ChatworkDecisionBranchesController < Api::BaseController
  def show
    @chatwork_decision_branch = ChatworkDecisionBranch.find_by!(access_token: params[:access_token])
    @decision_branch = @chatwork_decision_branch.decision_branch
    @bot = @chatwork_decision_branch.bot
    @chat = @chatwork_decision_branch.chat

    conn = Faraday.new(url: ENV['MYOPE_BOT_FRAMEWORK_HOST'])
    conn.post "/chatwork/#{@bot.token}/#{@chat.id}", {
      decisionBranchId: @decision_branch.id,
      decisionBranchBody: @decision_branch.body,
      room_id: @chatwork_decision_branch.room_id,
      from_account_id: @chatwork_decision_branch.from_account_id
    }.to_json
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
