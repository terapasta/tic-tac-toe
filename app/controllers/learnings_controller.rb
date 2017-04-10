class LearningsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def show
    render json: @bot.as_json(only: [:learning_status])
  end

  def update
    LearnJob.perform_later(@bot.id)
    @bot.update learning_status: :processing, learning_status_changed_at: Time.current
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
