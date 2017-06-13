class QuestionAnswers::SelectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question_answer
  before_action :set_bot

  def create
    @bot.add_selected_question_answer_ids(@question_answer.id)
    @bot.save
    @question_answer.selection = true
    @question_answer.save
    respond_to do |format|
      format.json { render json: @question_answer}
    end
  end

  def destroy
    @bot.remove_selected_question_answer_ids(@question_answer.id)
    @bot.save
    @question_answer.selection = false
    @question_answer.save
    respond_to do |format|
      format.json { render json: @question_answer}
    end
  end

  private
    def set_question_answer
      @question_answer = QuestionAnswer.find(params[:question_answer_id])
    end

    def set_bot
      @bot = Bot.find(params[:bot_id])
    end
end
