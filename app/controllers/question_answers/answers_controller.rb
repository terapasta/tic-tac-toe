class QuestionAnswers::AnswersController < ApplicationController
  include BotUsable
  before_action :authenticate_user!

  def show
    @bot = bots.find(params[:bot_id])
    @question_answer = @bot.question_answers.find(params[:question_answer_id])
    @answer = @question_answer.answer
    respond_to do |format|
      if @answer.present?
        format.json { render json: @answer.decorate.as_json(include: [:answer_files]), status: :ok }
      else
        format.json { render json: {}, status: :not_found }
      end
    end
  end
end
