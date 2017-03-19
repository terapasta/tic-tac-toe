class QuestionAnswers::AnswersController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  def show
    @bot = bots.find(params[:bot_id])
    @question_answer = @bot.question_answers.find(params[:question_answer_id])
    @answer = @question_answer.answer
    fail ActionController::RoutingError.new("Has not answer") if @answer.nil?
    respond_to do |format|
      format.json { render json: @answer.decorate.as_json, status: :ok }
    end
  end
end
