class Trainings::QuestionsController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training

  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'
    receive_and_reply!(@training, training_message)
    redirect_to bot_training_path(@bot, @training)
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = @bot.trainings.find(params[:training_id])
    end

    # def set_training_message
    #   @training_message = @training.training_messages.find(params[:id])
    # end

    def training_message_params
      params.require(:training_message).permit(:answer_id, :body)
    end
end
