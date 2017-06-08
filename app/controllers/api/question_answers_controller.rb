class Api::QuestionAnswersController < Api::BaseController
  def show
    @question_answer = QuestionAnswer.find(params[:id])
    authorize @question_answer
    render json: @question_answer
  end
end
