class SentenceSynonymsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @training_messages = @bot.training_messages
  end

  def new
    @training_message = TrainingMessage.pick_sentence_synonyms_not_enough(@bot, current_user)
    if @training_message.blank?
      flash[:error] = '未作業の文章がありませんでした'
      redirect_to root_path and return
    end
    3.times.map { @training_message.sentence_synonyms.build }
  end

  def create
    @training_message = @bot.training_messages.find(training_message_params[:id])
    @training_message.assign_attributes(training_message_params)
    @training_message.sentence_synonyms.each { |ss| ss.created_user = current_user }
    if @training_message.save
      redirect_to new_bot_sentence_synonym_path(@bot), notice: '登録しました。'
    else
      flash[:alert] = '登録に失敗しました。'
      render :new
    end
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def training_message_params
      params.require(:training_message).permit(:id, sentence_synonyms_attributes: [:body])
    end
end
