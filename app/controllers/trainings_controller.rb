class TrainingsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_training, only: [:show, :create, :destroy]

  def show
  end

  def edit
  end

  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'

    answer = Conversation.reply(training_message)
    @training.training_messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    @training.save!

    render :show
  end

  # def update
  #   if @training.update(training_params)
  #     flash[:notice] = '回答を更新しました'
  #   else
  #     flash[:notice] = '回答の更新に失敗しました'
  #   end
  #   redirect_to trainings_path
  # end

  def destroy
    @training.destroy
    render :show
  end

  private
    def set_training
      @training = Training.last || Training.create
    end

    # Only allow a trusted parameter "white list" through.
    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
