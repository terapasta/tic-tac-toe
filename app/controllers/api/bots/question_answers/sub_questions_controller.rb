class Api::Bots::QuestionAnswers::SubQuestionsController < Api::BaseController
  before_action :set_bot_and_question_answer

  def index
    render json: @question_answer.sub_questions, adapter: :json
  end

  def create
    @sub_question = @question_answer.sub_questions.build(permitted_attributes(SubQuestion))
    if @sub_question.save
      render json: @sub_question, adapter: :json
    else
      render_unprocessable_entity_error_json(@sub_question)
    end
  end

  def update
    @sub_question = @question_answer.sub_questions.find(params[:id])
    if @sub_question.update(permitted_attributes(@sub_question))
      render json: @sub_question, adapter: :json
    else
      render_unprocessable_entity_error_json(@sub_question)
    end
  end

  def destroy
    @sub_question = @question_answer.sub_questions.find(params[:id])
    @sub_question.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot_and_question_answer
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
      @question_answer = @bot.question_answers.find(params[:question_answer_id])
      authorize @question_answer, :show?
    end
end