class ExportsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot

  def index
  end

  def show
    Learning::Summarizer.new(@bot).summary
    send_data LearningTrainingMessage.to_csv(@bot), filename: 'learning_training_messages.csv', type: :csv
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
    end
end
