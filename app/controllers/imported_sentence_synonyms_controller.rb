class ImportedSentenceSynonymsController < ApplicationController
  include SentenceSynonymsOperatable
  before_action :authenticate_user!
  before_action :set_bot

  newrelic_ignore_apdex only: [:new]

  def index
    authorize SentenceSynonym
    SentenceSynonymsOperatable::IndexOperator.new(self).tap do |operator|
      if operator.need_alert?
        render :index_alert
      else
        @sentence_synonyms_all = @bot&.question_answers&.all&.count || QuestionAnswer.count
        @not_have_sentence_synonyms = @bot&.question_answers&.not_have_any_sentence_synonyms_count || QuestionAnswer.not_have_any_sentence_synonyms_count
        @sentence_synonyms_registration_number = @bot&.question_answers&.decorate&.classify_registered_sentence_synonyms_number || QuestionAnswer.all.decorate.classify_registered_sentence_synonyms_number
        operator.process
      end
    end
  end

  def new
    @question_answer = QuestionAnswer.pick_sentence_synonyms_not_enough(@bot, current_user)
    if @question_answer.blank?
      flash.now.alert = '未作業の文章がありませんでした'
    else
      @question_answer.build_sentence_synonyms_for(current_user)
    end
  end

  def create
    @question_answer = question_answers.find(question_answer_params[:id])
    @question_answer.assign_attributes(question_answer_params)
    if @question_answer.save
      redirect_to new_path, notice: '登録しました。'
    else
      logger.debug @question_answer.errors.full_messages
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
      if params[:bot_id].present? || params.dig(:filter, :bot_id).present?
        @bot = Bot.find(params[:bot_id].presence || params.dig(:filter, :bot_id))
      end
    end
end
