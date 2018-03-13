class Api::Bots::DecisionBranches::BulksController < Api::BaseController
  def destroy
    if decision_branch_ids.blank?
      render_not_found_json and return
    end

    set_bot

    @decision_branches = @bot.decision_branches.where(id: decision_branch_ids)

    if @decision_branches.count != decision_branch_ids.count
      render_not_found_json and return
    end

    ActiveRecord::Base.transaction do
      @decision_branches.map(&:destroy!)
    end

    render json: {}, status: :no_content
  end

  private
    def decision_branch_ids
      @decision_branch_ids ||= params[:decision_branch_ids].uniq
    end

    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :update?
    end
end