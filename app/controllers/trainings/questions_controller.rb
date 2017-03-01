class Trainings::QuestionsController < ApplicationController
  include Replyable
  include BotUsable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training

  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'
    receive_and_reply!(@training, training_message)
    redirect_to bot_training_path(@bot, @training)
  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    redirect_to bot_training_path(@bot, @training), alert: '質問を受け付けられませんでした'
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
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
