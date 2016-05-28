class TopsController < ApplicationController
  def show
    @answer_ids = [9]
    @texts = []
  end

  def create
    @answer_ids = params[:answer_ids]
    @texts = params[:texts] || []
    @texts << params[:text]
    # TODO ここで予測を実行して、answer_idsに追加する
    render :show
  end
end
