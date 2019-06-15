class QuestionAnswers::SelectionsController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable

  before_action :set_bot
  before_action :set_initial_selection, only: [:destroy, :move_higher, :move_lower]

  def index
    respond_to do |format|
      format.html do
        @current_page = current_page
        @per_page = 10 # QuestionAnswer.default_per_page
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
      end

      format.json do
        render json: @bot.selected_question_answers, adapter: :json
      end
    end
  end

  def create
    @question_answer = @bot.question_answers.find(params[:question_answer_id])
    @bot.initial_selections.build(question_answer_id: @question_answer.id)
    message = @bot.save ? {} : { alert: @bot.errors.full_messages.join(', ') }
    redirect_back message.merge(fallback_location: index_path)
  end

  def destroy
    @initial_selection.destroy!
    redirect_back fallback_location: index_path
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

  def move_higher
    @initial_selection.move_higher
    redirect_back fallback_location: index_path
  end

  def move_lower
    @initial_selection.move_lower
    redirect_back fallback_location: index_path
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_initial_selection
      @initial_selection = @bot.initial_selections.find(params[:id])
    end

    def index_path
      bot_question_answer_selections_path(@bot)
    end
end
