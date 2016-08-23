class Trainings::TrainingMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training

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
    redirect_to bot_training_path(@bot, @training)
  end

  def update
    training_message = TrainingMessage.find(params[:id])
    answer = Answer.find(training_message_params[:answer_id])
    if training_message.update(answer_id: training_message_params[:answer_id], body: answer.body)
      flash[:notice] = '回答を差し替えました'
    else
      flash[:notice] = '回答の差し替えに失敗しました'
    end

    if auto?
      training_messages = @training.training_messages.build(Message.guest.sample.to_training_message_attributes)

      # TODO #createと共通化してDRYにしたい
      responder = Conversation::Switcher.new.responder(training_message, session[:states])
      answers = responder.reply
      session[:states] = responder.states

      answers.each do |answer|
        answer_id = answer.is_a?(Answer) ? answer.id : nil  # Answerモデルの場合のみ学習させたいので、他のモデルの場合はanswer_idをnilにしておく
        @training.context = answer.try(:context)
        @training.training_messages.build(speaker: 'bot', answer_id: answer.try(:id), body: answer.try(:body))
      end
      @training.save!
    end

    redirect_to bot_training_path(@bot, @training, auto: params[:auto])
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = Training.find(params[:training_id])
    end

    def training_message_params
      params.require(:training_message).permit(:answer_id, :body)
    end

    def auto?
      params[:auto] == '1'
    end
end
