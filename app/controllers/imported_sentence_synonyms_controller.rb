class ImportedSentenceSynonymsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bot

  def index
    @imported_training_messages = @bot.imported_training_messages
  end

  def new
    @imported_training_message = ImportedTrainingMessage.pick_sentence_synonyms_not_enough(@bot, current_user)
    if @imported_training_message.blank?
      flash[:error] = '未作業の文章がありませんでした'
      redirect_to root_path and return
    end
    3.times.map { @imported_training_message.sentence_synonyms.build }
  end

  def create
    @imported_training_message = @bot.imported_training_messages.find(imported_training_message_params[:id])
    @imported_training_message.assign_attributes(imported_training_message_params)
    # HACK 他ユーザーのデータも上書きしてしまう問題の対処。ひとまず画面側にcreated_user_idをもたせた
    # @imported_training_message.sentence_synonyms.each { |ss| ss.created_user = current_user }
    if @imported_training_message.save
      redirect_to new_bot_imported_sentence_synonym_path(@bot), notice: '登録しました。'
    else
      logger.debug @imported_training_message.errors.full_messages
      flash[:alert] = '登録に失敗しました。'
      render :new
    end
  end

  def destroy
    @sentence_synonym = @bot.sentence_synonyms.find(params[:id])
    @sentence_synonym.destroy
    redirect_to bot_imported_sentence_synonyms_path(@bot), notice: '削除しました'
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id])
    end

    def imported_training_message_params
      params.require(:imported_training_message).permit(:id, sentence_synonyms_attributes: [:body, :created_user_id])
    end
end
