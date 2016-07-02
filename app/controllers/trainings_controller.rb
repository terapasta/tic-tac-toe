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

    answer = Conversation.new(training_message).reply
    @training.training_messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    @training.save!

    render :show
  end

  def destroy
    @training.destroy
    render :show
  end

  def complete
    # TODO ゴミデータが出来てしまう
    @training = Training.create!
    render :show
  end

  private
    def set_training
      @training = Training.last || Training.create!
    end

    def training_message_params
      params.require(:training_message).permit(:body)
    end
end
