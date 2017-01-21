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

  # def destroy
  #   respond_to do |format|
  #     format.html do
  #       @answer.destroy!
  #       redirect_to bot_answers_path(@bot), notice: '回答を削除しました。'
  #     end
  #     format.json do
  #       ActiveRecord::Base.transaction do
  #         @answer.self_and_deep_child_answers.map(&:destroy!)
  #       end
  #       render json: {}, status: :no_content
  #     end
  #   end
  # rescue => e
  #   respond_to do |format|
  #     format.html { raise e }
  #     format.json do
  #       logger.error e.message + e.backtrace.join("\n")
  #       render json: { error: e.message }, status: :internal_server_error
  #     end
  #   end
  # end

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
