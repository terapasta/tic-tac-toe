class LearningsController < ApplicationController
  before_action :authenticate_admin_user!

  def update
    test_scores_mean = Ml::Engine.new.learn
    flash[:notice] = "学習を実行しました。スコア: #{test_scores_mean}"
    redirect_to :back
  end
end
