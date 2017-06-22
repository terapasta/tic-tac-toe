class Api::QuestionAnswersController < Api::BaseController
  before_action :set_bot

  def show
    @question_answer = @bot.question_answers.find(params[:id])
    authorize @question_answer
    render json: @question_answer
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot
    end
end
