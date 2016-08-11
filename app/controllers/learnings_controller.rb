class LearningsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def update
    test_scores_mean = Ml::Engine.new(@bot.id).learn
    flash[:notice] = "学習を実行しました。スコア: #{test_scores_mean}"
    redirect_to :back
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end
end
