class QuestionAnswersController < ApplicationController
  # include BotUsable
  before_action :authenticate_user!

  before_action :set_bot
  before_action :set_question_answer, only: [:edit, :update, :destroy]

  autocomplete :answer, :body, full: true

  def index
    @question_answers = @bot.question_answers.order('question').page(params[:page])
  end

  # def create
  #   @answer = @bot.answers.build(answer_params)
  #   respond_to do |format|
  #     if @answer.save
  #       format.json { render json: @answer.decorate.as_json, status: :created }
  #     else
  #       format.json { render json: @answer.decorate.errors_as_json, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def update
  #   respond_to do |format|
  #     if @answer.update answer_params
  #       format.html { redirect_to bot_answers_path(@bot), notice: '回答を更新しました。' }
  #       format.json { render json: @answer.decorate.as_json, status: :ok }
  #     else
  #       format.html do
  #         flash.now.alert = '回答を更新できませんでした。'
  #         render :edit
  #       end
  #       format.json { render json: @answer.decorate.errors_as_json, status: :unprocessable_entity }
  #     end
  #   end
  # end

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

  #   def answer_params
  #     params.require(:answer).permit(:headline, :body)
  #   end
end
