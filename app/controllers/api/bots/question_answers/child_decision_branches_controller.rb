class Api::Bots::QuestionAnswers::ChildDecisionBranchesController < Api::BaseController
  before_action :set_bot
  before_action :set_question_answer

  def destroy
    @question_answer.decision_branches.map(&:destroy!)
    render json: {}, status: :no_content
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find(params[:question_answer_id])
      authorize @question_answer
    end
end
