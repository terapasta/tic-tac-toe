class ConversationTreesController < ApplicationController
  before_action :authenticate_user!

  def show
    @bot = current_user.bots.find params[:bot_id]
    @answers = @bot.answers
      .includes(:decision_branches)
      .top_level(@bot.id)
      .order('id desc')
      .decorate
    @all_answers = @bot.answers.order('id desc').decorate
    @decision_branches = @bot.decision_branches.decorate
  end
end
