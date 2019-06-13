class InitialSelectionsController < ApplicationController
  include BotUsable

  before_action :set_bot
  before_action :set_initial_selection, only: [:destroy, :move_higher, :move_lower]

  def index
    @initial_selections = @bot.initial_selections.includes(:question_answer)
    @question_answers = @bot.question_answers.select(:id, :question).where.not(id: @initial_selections.map(&:question_answer_id))
  end

  def create
    if @bot.initial_selections.count >= Bot::MaxInitialSelectionsCount
      redirect_to index_path, alert: '初期質問をこれ以上追加できません' and return
    end
    @question_answer = @bot.question_answers.find(params[:question_answer_id])
    @initial_selection = @bot.initial_selections.build(question_answer: @question_answer)
    message = if @initial_selection.save
      { notice: '初期質問を追加しました' }
    else
      { alert: '初期質問を追加できませんでした' }
    end
    redirect_to index_path, message
  end

  def destroy
    @initial_selection.destroy!
    redirect_to index_path
  end

  def move_higher
    @initial_selection.move_higher
    redirect_to index_path
  end
  
  def move_lower
    @initial_selection.move_lower
    redirect_to index_path
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def set_initial_selection
      @initial_selection = @bot.initial_selections.find(params[:id])
    end

    def index_path
      bot_initial_selections_path(@bot)
    end
end