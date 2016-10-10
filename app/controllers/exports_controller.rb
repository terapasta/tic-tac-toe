class ExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def show
    TrainingMessageConverter.new(@bot).convert
    send_data LearningTrainingMessage.to_csv(@bot), filename: 'learning_training_messages.csv', type: :csv
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end
end
