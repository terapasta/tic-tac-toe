class LearningsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def update
    if Learning::Summarizer.new(@bot).summary
      LearningTrainingMessage.amp!(@bot)
      scores = Ml::Engine.new(@bot.id).learn
      @bot.score ||= @bot.build_score
      @bot.score.update(scores)
      flash[:notice] = "学習を実行しました。スコア: #{@bot.score.accuracy}"
    else
      flash[:error] = '学習の実行に失敗しました。'
    end
    redirect_to :back
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end
end
