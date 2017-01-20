class Answers::QuestionAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_answer

  def index
    respond_to do |format|
      format.json { render json: @answer.question_answers }
    end
  end

  private
    def set_bot
      @bot = current_user.bots.find params[:bot_id]
    end

    def set_answer
      @answer = @bot.answers.find params[:answer_id]
    end
end
