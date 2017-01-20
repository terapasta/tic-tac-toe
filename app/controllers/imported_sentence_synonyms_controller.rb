class ImportedSentenceSynonymsController < ApplicationController
  include SentenceSynonymsOperatable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    authorize SentenceSynonym
    @imported_training_messages = imported_training_messages
    @target_date = parse_target_date
  end

  def new
    @imported_training_message = ImportedTrainingMessage.pick_sentence_synonyms_not_enough(@bot, current_user)
    if @imported_training_message.blank?
      redirect_to root_path, alert: '未作業の文章がありませんでした' and return
    end
    @imported_training_message.build_sentence_synonyms_for(current_user)
  end

  def create
    @imported_training_message = imported_training_messages.find(imported_training_message_params[:id])
    @imported_training_message.assign_attributes(imported_training_message_params)
    if @imported_training_message.save
      redirect_to new_path, notice: '登録しました。'
    else
      logger.debug @imported_training_message.errors.full_messages
      flash.now.alert = '登録に失敗しました。'
      render :new
    end
  end

  def destroy
    @sentence_synonym = sentence_synonyms.find(params[:id])
    @sentence_synonym.destroy
    redirect_to index_path, notice: '削除しました'
  end

  private
    def set_bot
      @bot = Bot.find(params[:bot_id]) if params[:bot_id].present?
    end

    def parse_target_date
      year = params.dig(:filter, 'target_date(1i)')
      month = params.dig(:filter, 'target_date(2i)')
      day = params.dig(:filter, 'target_date(3i)')
      unless [year, month, day].include?(nil)
        Date.new(year.to_i, month.to_i, day.to_i)
      end
    end
end
