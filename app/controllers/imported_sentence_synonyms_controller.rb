class ImportedSentenceSynonymsController < ApplicationController
  include SentenceSynonymsOperatable
  before_action :authenticate_user!
  before_action :set_bot

  def index
    authorize SentenceSynonym
    @question_answers = @bot.question_answers
    @target_date = parse_target_date
  end

  def new
    @question_answer = QuestionAnswer.pick_sentence_synonyms_not_enough(@bot, current_user)
    if @question_answer.blank?
      flash[:error] = '未作業の文章がありませんでした'
      redirect_to root_path and return
    end
    @question_answer.build_sentence_synonyms_for(current_user)
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
