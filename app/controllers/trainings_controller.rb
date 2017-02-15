class TrainingsController < ApplicationController
  include BotUsable
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training, only: [:show, :create, :destroy]

  def show
    @guest_training_message = TrainingMessage.new(training: @training)
  end

  def new
    @training = @bot.trainings.new
    @training.training_messages << @training.build_start_message
    flash.now.notice = "新しいスレッド#{@training.save ? 'が開始されました' : 'の開始に失敗しました'}"
    @guest_training_message = @training.training_messages.build
    render :show
  end

  def autocomplete_answer_body
    term = params[:term]
    render json: @bot.answers.where('body like ?', "%#{term}%").map { |answer|
      { id: answer.id, label: answer.body, value: answer.body, headline: answer.headline }
    }
  end

  private
    def set_bot
      @bot = bots.find(params[:bot_id])
      authorize @bot, :show?
    end

    def set_training
      @training = Training.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
