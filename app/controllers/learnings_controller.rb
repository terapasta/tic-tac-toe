class LearningsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def show
    render_learning_status
  end

  def update
    LearnJob.perform_later(@bot.id)
    @bot.update(learning_status: :processing)
    render_learning_status
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end

    def render_learning_status
      render json: @bot.as_json(only: [:learning_status])
    end
end
