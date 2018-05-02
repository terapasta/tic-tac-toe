class QuestionAnswers::SelectionsController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable

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
          without_ids: Array(@bot.selected_question_answers.map(&:id))
        )
        @question_answers = @q.result
        @selected_question_answers = params[:page].to_i > 1 ? [] : @bot.selected_question_answers.to_a
      end

      format.json do
        render json: @bot.selected_question_answers, adapter: :json
      end
    end
  end

  def create
    @bot.initial_selections.create(question_answer_id: @question_answer.id)
    @bot.save
    respond_to do |format|
      format.json { render json: @question_answer }
    end
  end

  def destroy
    @bot.initial_selections.find_by(question_answer_id: @question_answer.id)&.destroy
    @bot.save
    respond_to do |format|
      format.json { render json: @question_answer }
    end
  end

  def update
    ids = params.permit![:selected_question_answer_ids]
    qa_ids = @bot.question_answers.where(id: ids).pluck(:id)
    sorted_qa_ids = ids.map{ |id| qa_ids.detect{ |qa_id| qa_id == id } }.compact
    ActiveRecord::Base.transaction do
      @bot.initial_selections.map(&:destroy!)
      sorted_qa_ids.each.with_index(1){ |id, i| @bot.initial_selections.create!(question_answer_id: id, position: i)  }
    end
    render json: @bot.selected_question_answers
  rescue => e
    logger.error e.message
    render json: @bot.errors.full_messages, status: :unprocessable_entity
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
