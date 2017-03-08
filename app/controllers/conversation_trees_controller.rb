class ConversationTreesController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  def show
    @bot = bots.find params[:bot_id]
    @question_answers = @bot.question_answers.order(created_at: :desc).decorate
    @answers = @bot.answers
      .includes(:decision_branches)
      .top_level(@bot.id)
      .order('id desc')
      .decorate
    @all_answers = @bot.answers.order('id desc').decorate
    @decision_branches = @bot.decision_branches.decorate
  end
end
