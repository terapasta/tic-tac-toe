class QuestionAnswersController < ApplicationController
  include BotUsable
  include QuestionAnswerSearchable
  before_action :authenticate_user!
  before_action :pundit_auth

  before_action :set_bot
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_topic_tags, only: [:index, :headless]
  before_action :set_search_result, only: [:index, :headless]
  autocomplete :answer, :body, full: true

  def index
    @topic_tags = @bot.topic_tags
    @search_result = params.dig(:topic, :id)
    @keyword = params[:keyword]
    @q = @bot.question_answers
      .topic_tag(params.dig(:topic, :id))
      .includes(:decision_branches, :topic_tags)
      .order('question')
      .page(params[:page])
      .keyword(params[:keyword])
      .search(params[:q])
    @question_answers = @q.result
  end

  def show
    respond_to do |format|
      format.json do
        render json: @question_answer.decorate.as_json(include: [:topic_tags])
      end
    end
  end

  def new
    @question_answer = @bot.question_answers.build(
      question: params[:question],
      answer_attributes: { body: params[:answer] }
    )
  end

  def create
    respond_to do |format|
      @question_answer = @bot.question_answers.build(question_answer_params)
      if @question_answer.save
        format.html { redirect_to bot_question_answers_path(@bot), notice: '登録しました。' }
        format.json { render json: @question_answer.decorate.as_json, status: :created }
      else
        format.html do
          flash.now.alert = '登録できませんでした。'
          render :edit
        end
        format.json { render json: @question_answer.decorate.errors_as_json, status: :unprocessable_entity }
      end
    end
  end

  def update
    answer_params = question_answer_params.delete(:answer_attributes)

    ActiveRecord::Base.transaction do
      @question_answer.update!(question_answer_params)
      if answer_params.present?
        if @question_answer.answer.present?
          AnswerUpdateService.new(@bot, @question_answer.answer, answer_params).process!
        else
          @question_answer.update!({ answer_attributes: answer_params })
        end
      end
    end

    respond_to do |format|
      format.html do
        redirect_to edit_bot_question_answer_path(@bot, @question_answer), notice: '更新しました。'
      end
      format.json { render json: @question_answer.decorate.as_json, status: :ok }
    end
  rescue => e
    logger.error e.message + e.backtrace.join("\n")
    respond_to do |format|
      format.html do
        flash.now.alert = '更新できませんでした。'
        render :edit
      end
      format.json { render json: @question_answer.decorate.errors_as_json, status: :unprocessable_entity }
    end
  end

  def destroy
    respond_to do |format|
      begin
        format.html do
          @question_answer.destroy!
          redirect_to bot_question_answers_path(@bot), notice: '削除しました。'
        end
        format.json do
          ActiveRecord::Base.transaction do
            Array(@question_answer.answer&.self_and_deep_child_answers).map(&:destroy!)
            @question_answer.destroy!
          end
          render json: {}, status: :no_content
        end
      rescue => e
        format.html { raise e }
        format.json do
          logger.error e.message + e.backtrace.join("\n")
          render json: { error: e.message }, status: :internal_server_error
        end
      end
    end
  end

  def autocomplete_answer_body
    render json: @bot.answers.search_by(params[:term]).as_json(only: [:id, :body], methods: [:value])
  end

  def headless
    @question_answers = search_question_answer(@bot).result
  end

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find params[:id]
    end

    def set_topic_tags
      @topic_tags = @bot.topic_tags
    end

    def set_search_result
      @search_result = params.dig(:topic, :id)
      @keyword = params[:keyword]
    end

    def pundit_auth
      authorize QuestionAnswer
    end

    def question_answer_params
      @question_answer_params ||= permitted_attributes(@question_answer || QuestionAnswer).tap do |prm|
        if prm[:answer_attributes].present?
          prm[:answer_attributes][:bot_id] = @bot.id
        end
      end
    end
end
