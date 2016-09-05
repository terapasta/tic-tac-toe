class Trainings::DecisionBranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot
  before_action :set_training

  def new
  end

  private
    def set_bot
      @bot = current_user.bots.find(params[:bot_id])
    end

    def set_training
      @training = Training.find(params[:training_id])
    end

    # def training_message_params
    #   params.require(:training_message).permit(:answer_id, :body)
    # end
end
