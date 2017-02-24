class QuestionAnswersController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :pundit_auth

  before_action :set_bot
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]

  autocomplete :answer, :body, full: true

  def index
    @question_answers = @bot.question_answers.includes(:decision_branches).order('question').page(params[:page])
  end

  def show
    respond_to do |format|
      format.json do
        render json: @question_answer.decorate.as_json
      end
    end
  end

  def new
    @question_answer = @bot.question_answers.build
  end

  def create
    @question_answer = @bot.question_answers.build(permitted_attributes(QuestionAnswer) )
    if @question_answer.save
      redirect_to bot_question_answers_path(@bot), notice: '登録しました。'
    else
      flash.now.alert = '登録できませんでした。'
      render :edit
    end
  end

  def update
    respond_to do |format|
      if @question_answer.update(permitted_attributes(@question_answer) )
        format.html { redirect_to bot_question_answers_path(@bot), notice: '更新しました。' }
        format.json { render json: @question_answer.decorate.as_json, status: :ok }
      else
        format.html do
          flash.now.alert = '更新できませんでした。'
          render :edit
        end
        format.json { render json: @question_answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      begin
        @question_answer.destroy!
        format.html { redirect_to bot_question_answers_path(@bot), notice: '削除しました。' }
        format.json { render json: {}, status: :no_content }
      rescue => e
        format.html { raise e }
        format.json do
          logger.error e.message + e.backtrace.join("\n")
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end

  def autocomplete_answer_body
    render json: @bot.answers.search_by(params[:term]).as_json(only: [:id, :body, :headline], methods: [:value])
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find params[:id]
    end

    def pundit_auth
      authorize QuestionAnswer
    end
end
