class Api::Bots::InitialSelectionsController < Api::BaseController
  before_action :set_bot

  def index
    @initial_selections = @bot.initial_selections
    render json: @initial_selections, adapter: :json
  end

  def create
    @question_answer = @bot.question_answers.find(params[:question_answer_id])
    @bot.initial_selections.build(question_answer: @question_answer)
    @bot.save!
    render json: @bot.initial_selections.last, adapter: :json, status: :created
  end

  def destroy
    @initial_selection = @bot.initial_selections.find(params[:id])
    @initial_selection.destroy!
    render json: {}, status: :no_content
  end

  def move_higher
    @initial_selection = @bot.initial_selections.find(params[:id])
    @initial_selection.move_higher
    render json: @initial_selection, adapter: :json
  end

  def move_lower
    @initial_selection = @bot.initial_selections.find(params[:id])
    @initial_selection.move_lower
    render json: @initial_selection, adapter: :json
  end

  private
    def set_bot
      @token = params.require(:bot_token)
      @bot = Bot.eager_load(initial_selections: [:question_answer]).find_by!(token: @token)
    end
end