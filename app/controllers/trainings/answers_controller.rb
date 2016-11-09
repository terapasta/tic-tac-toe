class Trainings::AnswersController < ApplicationController
  include Replyable

  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training
  before_action :set_answer, only: [:update]

  def edit
    @message = @training.training_messages.build(answer_id: params[:id])
    @message.speaker = 'bot'
    @message.save!
    render :new
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_answer
      @answer = @bot.answers.find(params[:id])
    end

    def set_training
      @training = Training.find(params[:training_id])
    end

    def answer_params
      params.require(:answer).permit(:body, decision_branches_attributes: [:id, :body, :_destroy])
    end
end
