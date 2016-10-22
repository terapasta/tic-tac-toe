class TrainingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training, only: [:show, :create, :destroy]

  autocomplete :answer, :body, full: true

  def show
    @guest_training_message = @training.training_messages.build
  end

  def new
    @training = @bot.trainings.new
    @training.training_messages << @training.build_start_message
    if @training.save
      flash[:notice] = '新しいスレッドが開始されました'
    else
      flash[:notice] = '新しいスレッドの開始に失敗しました'
    end
    @guest_training_message = @training.training_messages.build
    render :show
  end

  def autocomplete_answer_body
    term = params[:term]
    render json: @bot.answers.where('body like ?', "%#{term}%").map { |answer|
      { id: answer.id, label: answer.body, value: answer.body }
    }
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = Training.find(params[:id])
    end

    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
