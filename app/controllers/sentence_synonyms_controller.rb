class SentenceSynonymsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def new
    @target_training_message = @bot.training_messages.sample
    @training_messages = 3.times.map { TrainingMessage.new }
  end
  #
  # def create
  #   @training_text = TrainingText.new(training_text_params)
  #   if @training_text.save
  #     redirect_to new_admin_training_text_path, notice: '登録しました。'
  #   else
  #     flash[:alert] = '登録に失敗しました。'
  #     render :new
  #   end
  # end
  #
  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end
  #   def training_text_params
  #     params.require(:training_text).permit(:body, :tag_list)
  #   end
end
