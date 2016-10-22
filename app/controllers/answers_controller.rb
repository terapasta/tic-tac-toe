class AnswersController < ApplicationController
  before_action :set_bot

  def index
    @answers = @bot.answers
  end

  def new
  end

  def edit
  end

  private

    def set_bot
      @bot = Bot.find params[:bot_id]
    end
end
