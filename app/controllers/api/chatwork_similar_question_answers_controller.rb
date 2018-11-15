class Api::ChatworkSimilarQuestionAnswersController < Api::BaseController
  def show
    @chatwork_similar_question_answer = ChatworkSimilarQuestionAnswer.find_by!(access_token: params[:access_token])
    @question_answer = @chatwork_similar_question_answer.question_answer
    @bot = @chatwork_similar_question_answer.bot
    @chat = @chatwork_similar_question_answer.chat
    ChatworkSimilarQuestionAnswerJob.perform_later(@bot, @chat, @question_answer, @chatwork_similar_question_answer)

    render template: 'api/chatwork_similar_question_answers/show.html.slim'
  end

  def create
    @chatwork_similar_question_answer = ChatworkSimilarQuestionAnswer.new(chatwork_similar_question_answer_params)
    @sub_question = SubQuestion.find_by(id: params[:chatwork_similar_question_answer][:question_answer_id])
    if @sub_question.present?
      @chatwork_similar_question_answer.assign_attributes(
        question_answer_id: @sub_question.question_answer_id,
        question: @sub_question.question
      )
    end
    if @chatwork_similar_question_answer.save
      render json: @chatwork_similar_question_answer, adapter: :json, status: :created
    else
      render_unprocessable_entity_error_json(@chatwork_similar_question_answer)
    end
  end

  private
    def chatwork_similar_question_answer_params
      params.require(:chatwork_similar_question_answer).permit(
        :question_answer_id,
        :chat_id,
        :room_id,
        :from_account_id
      )
    end
end