class QuestionAnswers::SelectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question_answer


  def create
    @question_answer.selectable_by_owner = true
    @question_answer.save
    respond_to do |format|
      format.json { render json: @question_answer}
    end
  end

  def destroy
    @question_answer.selectable_by_owner = false
    @question_answer.save
    respond_to do |format|
      format.json { render json: @question_answer}
    end
  end

  private
    def set_question_answer
      @question_answer = QuestionAnswer.find(params[:question_answer_id])
    end
end
