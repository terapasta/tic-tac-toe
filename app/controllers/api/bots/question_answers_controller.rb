class Api::Bots::QuestionAnswersController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer, only: [:update, :destroy]


  def index
    if params[:data_format] == 'tree'
      @question_answers = @bot.question_answers
        .includes(:sub_questions, :decision_branches)
        .order(created_at: :desc)
        .page(params[:page])
        .per(params[:per].presence || 50)
        .decorate
      @decision_branches = @bot.decision_branches.decorate

      tree = @question_answers.make_tree(@decision_branches)
      render json: {
        questionsTree: tree,
        questionsRepo: @question_answers.as_repo_json,
        searchIndex: @question_answers.make_index_json(tree, @decision_branches)
      }
      response.headers['X-Total-Pages'] = @question_answers.object.total_pages
    else
      @question_answers = @bot.question_answers.keyword_for_answer(params[:q])
      render json: @question_answers, adapter: :json
    end
  end

  def show
    @question_answer = @bot.question_answers.find(params[:id])
    authorize @question_answer
    render json: @question_answer
  end

  def create
    @question_answer = @bot.question_answers.build(permitted_attributes(QuestionAnswer))
    authorize @question_answer
    if @question_answer.save
      @bot.learn_later
      logger.debug 'succeeded'
      render json: @question_answer, adapter: :json, status: :created, includes: 'decision_branches'
    else
      logger.debug 'failed'
      render json: { errors: @question_answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question_answer.update(permitted_attributes(@question_answer))
      @bot.learn_later
      render json: @question_answer, adapter: :json, status: :ok
    else
      render json: { errors: @question_answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      Array(@question_answer.self_and_deep_child_decision_branches).map(&:destroy!)
    end
    @bot.learn_later
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:id])
      authorize @question_answer
    end
end
