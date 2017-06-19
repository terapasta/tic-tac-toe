class QuestionAnswers::SelectionsController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable

  before_action :authenticate_user!
  before_action :set_question_answer, only: [:create, :destroy]
  before_action :set_bot

  def index
    respond_to do |format|
      format.html do
        @current_page = current_page
        @per_page = QuestionAnswer.default_per_page
        @topic_id = params.dig(:topic, :id)
        @q = search_question_answers(
          bot: @bot,
          topic_id: @topic_id,
          keyword: params[:keyword],
          q: params[:q],
          page: @current_page,
          per_page: @per_page,
        )
        @question_answers = @q.result
      end

      format.json do
        @question_answers = @bot.selected_question_answers
        render json: @question_answers, adapter: :json
      end
    end
  end

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
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end

    def index_path_helper_name
      :bot_question_answers_selections_path
    end
end
