class Trainings::TrainingMessagesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_training
  #
  def create
    training_message = @training.training_messages.build(training_message_params)
    training_message.speaker = 'guest'

    responder = Conversation::Switcher.new.responder(training_message, session[:states])
    answers = responder.reply
    session[:states] = responder.states

    @messages = answers.map do |answer|
      answer_id = answer.is_a?(Answer) ? answer.id : nil  # Answerモデルの場合のみ学習させたいので、他のモデルの場合はanswer_idをnilにしておく
      @training.context = answer.context
      @training.training_messages.build(speaker: 'bot', answer_id: answer.id, body: answer.body)
    end

    @training.save!
    redirect_to training_path(@training)
  end

  def update
    training_message = TrainingMessage.find(params[:id])
    answer = Answer.find(training_message_params[:answer_id])
    if training_message.update(answer_id: training_message_params[:answer_id], body: answer.body)
      flash[:notice] = '回答を差し替えました'
    else
      flash[:notice] = '回答の差し替えに失敗しました'
    end
    redirect_to training_path(@training)
  end

  private
    def set_training
      @training = Training.find(params[:training_id])
    end
  #
  #   def answer_params
  #     params.require(:answer).permit(:body)
  #   end
  #
    def training_message_params
      params.require(:training_message).permit(:answer_id, :body)
    end
end
