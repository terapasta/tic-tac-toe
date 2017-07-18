class Api::Bots::QuestionAnswersController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer, only: [:update, :destroy]

  def show
    @question_answer = @bot.question_answers.find(params[:id])
    authorize @question_answer
    render json: @question_answer
  end

  def create
    @question_answer = @bot.question_answers.build(permitted_attributes(QuestionAnswer))
    authorize @question_answer
    if @question_answer.save
      logger.debug 'succeeded'
      render json: @question_answer, adapter: :json, status: :created, includes: 'decision_branches'
    else
      logger.debug 'failed'
      render json: { errors: @question_answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question_answer.update(permitted_attributes(@question_answer))
      render json: @question_answer, adapter: :json, status: :ok
    else
      render json: { errors: @question_answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question_answer.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:id])
      authorize @question_answer
    end
end
