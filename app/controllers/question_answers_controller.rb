class QuestionAnswersController < ApplicationController
  include BotUsable
  include QuestionAnswersSearchable
  before_action :authenticate_user!

  before_action :set_bot
  before_action :set_question_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_topic_tags, only: [:index]
  autocomplete :answer, :body, full: true

  def index
    authorize QuestionAnswer
    session[:question_answers_queries] = request.query_parameters
    @topic_tags = @bot.topic_tags
    @keyword = params[:keyword]
    @current_page = current_page
    @per_page = 2 #QuestionAnswer.default_per_page
    @topic_id = params.dig(:topic, :id)
    @q = search_question_answers(
      bot: @bot,
      topic_id: @topic_id,
      keyword: params[:keyword],
      q: params[:q],
      page: @current_page,
      per_page: @per_page,
    )
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
    authorize @question_answer
  end

  def create
    respond_to do |format|
      @question_answer = @bot.question_answers.build(question_answer_params)
      authorize @question_answer
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
    ActiveRecord::Base.transaction do
      if @question_answer.answer.blank?
        @question_answer.update!(question_answer_params)
      else
        answer_params = question_answer_params.delete(:answer_attributes)
        @question_answer.update!(question_answer_params)
        if answer_params.present?
          AnswerUpdateService.new(@bot, @question_answer.answer, answer_params).process!
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
    logger.error e.message
    logger.error e.backtrace.join("\n")
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

  private
    def set_bot
      @bot = bots.find params[:bot_id]
    end

    def set_question_answer
      @question_answer = @bot.question_answers.find params[:id]
      authorize @question_answer
    end

    def set_topic_tags
      @topic_tags = @bot.topic_tags
    end

    def question_answer_params
      @question_answer_params ||= permitted_attributes(@question_answer || QuestionAnswer).tap do |prm|
        if prm[:answer_attributes].present?
          prm[:answer_attributes][:bot_id] = @bot.id
        end
      end
    end

    def index_path_helper_name
      :bot_question_answers_path
    end
end
