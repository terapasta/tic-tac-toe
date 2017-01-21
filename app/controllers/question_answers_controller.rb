class QuestionAnswersController < ApplicationController
  # include BotUsable
  before_action :authenticate_user!

  before_action :set_bot
  before_action :set_question_answer, only: [:edit, :update, :destroy]

  autocomplete :answer, :body, full: true

  def index
    @question_answers = @bot.question_answers.order('question').page(params[:page])
  end

  def new
    @question_answer = @bot.question_answers.build
  end

  def create
    @question_answer = @bot.question_answers.build(question_answer_params)
    if @question_answer.save
      redirect_to bot_question_answers_path(@bot), notice: '登録しました。'
    else
      flash.now.alert = '登録できませんでした。'
      render :edit      
    end
  end

  def update
    if @question_answer.update(question_answer_params)
      redirect_to bot_question_answers_path(@bot), notice: '更新しました。'
    else
      flash.now.alert = '更新できませんでした。'
      render :edit      
    end
  end

  def destroy
    @question_answer.destroy!
    redirect_to bot_question_answers_path(@bot), notice: '削除しました。'
  end

  private
    def set_bot
      @bot = current_user.bots.find params[:bot_id]
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find params[:id]
    end

    def question_answer_params
      params.require(:question_answer).permit(:question, :answer_id)
    end
end
