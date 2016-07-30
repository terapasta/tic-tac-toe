class LearningsController < ApplicationController
  before_action :authenticate_admin_user!

  def update
    client = MessagePack::RPC::Client.new('127.0.0.1', 6000)  # TODO 共通化する
    test_scores_mean = client.call(:learn)
    flash[:notice] = "学習を実行しました。スコア: #{test_scores_mean}"
    redirect_to :back
  end
end
