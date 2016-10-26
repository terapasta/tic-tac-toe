class AnswersController < ApplicationController
  before_action :authenticate_user!

  before_action :set_bot
  before_action :set_answer, only: [:edit, :update, :destroy]

  def index
    @answers = @bot.answers.page(params[:page])
  end

  def update
    if @answer.update answer_params
      redirect_to bot_answers_path(@bot), notice: '回答を更新しました。'
    else
      flash[:alert] = '回答を更新できませんでした。'

      render :edit
    end
  end

  def destroy
    @answer.destroy!

    redirect_to bot_answers_path(@bot), notice: '回答を削除しました。'
  end

  private

    def set_bot
      @bot = Bot.find params[:bot_id]
    end

    def set_answer
      @answer = @bot.answers.find params[:id]
    end

    def answer_params
      params.require(:answer).permit(:body)
    end
end