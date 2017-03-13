class AnswersController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  before_action :set_bot
  before_action :set_answer, only: [:edit, :update, :destroy]

  def index
    @q = @bot.answers.ransack(params[:q])
    @answers = @q.result(distinct: true).order('id desc').page(params[:page])
  end

  def show
    @answer = @bot.answers.find_by(id: params[:id])
    respond_to do |format|
      if @answer.present?
        format.json { render json: @answer.decorate.as_json }
      else
        format.json { render json: {}, status: :not_found }
      end
    end
  end

  def create
    @answer = @bot.answers.build(answer_params)
    respond_to do |format|
      if @answer.save
        format.json { render json: @answer.decorate.as_json, status: :created }
      else
        format.json { render json: @answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update answer_params
        format.html { redirect_to bot_answers_path(@bot), notice: '回答を更新しました。' }
        format.json { render json: @answer.decorate.as_json, status: :ok }
      else
        format.html do
          flash.now.alert = '回答を更新できませんでした。'
          render :edit
        end
        format.json { render json: @answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        @answer.destroy!
        redirect_to bot_answers_path(@bot), notice: '回答を削除しました。'
      end
      format.json do
        ActiveRecord::Base.transaction do
          @answer.self_and_deep_child_answers.map(&:destroy!)
        end
        render json: {}, status: :no_content
      end
    end
  rescue => e
    respond_to do |format|
      format.html { raise e }
      format.json do
        logger.error e.message + e.backtrace.join("\n")
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end

  private

    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_answer
      @answer = @bot.answers.find params[:id]
    end

    def answer_params
      params.require(:answer).permit(:headline, :body)
    end
end
