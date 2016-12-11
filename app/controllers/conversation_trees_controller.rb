class ConversationTreesController < ApplicationController
  before_action :authenticate_user!

  def show
    @bot = Bot.find params[:bot_id]
    @answers = @bot.answers.order('id desc').decorate
    @decision_branches = @bot.decision_branches.decorate
  end
end
