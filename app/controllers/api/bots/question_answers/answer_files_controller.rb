class Api::Bots::QuestionAnswers::AnswerFilesController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer

  def create
    @answer_file = @question_answer.answer_files.build(permitted_attributes(AnswerFile))
    if @answer_file.save
      render json: @answer_file, adapter: :json, status: 201
    else
      render_unprocessable_entity_error_json(@answer_file)
    end
  end

  def destroy
    @answer_file = @question_answer.answer_files.find(params[:id])
    @answer_file.destroy!
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :update?
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:question_answer_id])
      authorize @question_answer, :update?
    end
end